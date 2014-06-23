require 'will_paginate/array'

class PronosticsController < ApplicationController
  before_filter :store_location, :only => [:create]
  before_filter :authenticate_user!,
                :only => [:create,:edit]
  layout "pronostic_share", :only => :show

  # GET /pronostics
  # GET /pronostics.json
  def index
    if(params.has_key?(:sortbyuser))
      @pronostics=Pronostic.find_all_by_user_id(params[:sortbyuser]).paginate(page: params[:page], per_page: 20)
    else
      @pronostics = Pronostic.paginate(page: params[:page], per_page: 20).order('created_at DESC')
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pronostics }
    end
  end

  # GET /pronostics/1
  # GET /pronostics/1.json
  def show
    session.delete :pronostic_before_signin
    @pronostic = Pronostic.find(params[:id])
    @url_s3_pronostic=getAmazonLink+@pronostic.id.to_s+".jpg"
    @match_phrase=@pronostic.match.phrase

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pronostic }
    end
  end

  def getAmazonLink
    "http://footibon.s3.amazonaws.com/"
  end

  # GET /pronostics/new
  # GET /pronostics/new.json
  def new
    @match =Match.find(params["match_id"])
    @pronostic = Pronostic.new
    @pronostic.match=@match

    if current_user && !current_user.is_admin
      old_pronostic=Pronostic.where("user_id = ? AND match_id = ?",current_user.id,@pronostic.match.id).first
      if old_pronostic
        redirect_to pronostic_path(old_pronostic), :flash => { :error => "Vous avez déjà pronostiqué ce match" }
        return
      end
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pronostic }
    end
  end

  # GET /pronostics/1/edit
  def edit
    @pronostic = Pronostic.find(params[:id])
  end

  # POST /pronostics
  # POST /pronostics.json
  def create
    if session[:pronostic_before_signin]
      @pronostic = session[:pronostic_before_signin]
    else
      @pronostic = Pronostic.new(params[:pronostic])
    end

    @pronostic.user = current_user

    first_image = MiniMagick::Image.open "#{Rails.root}/app/assets/images/scoreboard.jpg"


    avatar_joueur=MiniMagick::Image.open process_uri(@pronostic.user.avatar)
    avatar_joueur.resize "60x60!"
    equipe1 = MiniMagick::Image.open @pronostic.match.equipe1.drapeau
    equipe1.resize "70x46!"
    equipe2 = MiniMagick::Image.open @pronostic.match.equipe2.drapeau
    equipe2.resize "70x46!"
    result = first_image.composite(equipe1) do |c|
      c.compose "Over" # OverCompositeOp
      c.geometry "+375+240" # copy second_image onto first_image from (20, 20)
    end
    result = result.composite(equipe2) do |c|
      c.compose "Over" # OverCompositeOp
      c.geometry "+730+240" # copy second_image onto first_image from (20, 20)
    end
    result = result.composite(avatar_joueur) do |c|
      c.compose "Over" # OverCompositeOp
      c.geometry "+560+125" # copy second_image onto first_image from (20, 20)
    end
    nom_equipe1=I18n.transliterate(@pronostic.match.equipe1.nom).gsub("'", '')
    nom_equipe2=I18n.transliterate(@pronostic.match.equipe2.nom).gsub("'", '')
    result.combine_options do |c|
      c.font "#{Rails.root}/public/signika-bold.ttf"
      c.pointsize '25'
      c.fill("#ffffff")
      c.draw "text 380,145 '#{nom_equipe1}'"
      c.draw "text 735,145 '#{nom_equipe2}'"
      c.pointsize '100'
      c.draw "text 380,220 '#{@pronostic.score1}'"
      c.draw "text 740,220 '#{@pronostic.score2}'"
    end

    file_tmp_path="#{Rails.root}/tmp/output.jpg"
    result.write file_tmp_path

    respond_to do |format|
      if @pronostic.save
        store_in_s3(file_tmp_path, @pronostic.id)
        share_on_footibon_page_facebook @pronostic
        if current_user && (current_user.uid=="10150002291408540" || current_user.uid=="313687985456952") #||(current_user && current_user.is_admin)
            share_on_facebook @pronostic
        end
        format.html { redirect_to @pronostic, notice: 'Pronostic was successfully created.' }
        format.json { render json: @pronostic, status: :created, location: @pronostic }
      else
        format.html { render action: "new" }
        format.json { render json: @pronostic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pronostics/1
  # PUT /pronostics/1.json
  def update
    @pronostic = Pronostic.find(params[:id])

    respond_to do |format|
      if @pronostic.update_attributes(params[:pronostic])
        format.html { redirect_to @pronostic, notice: 'Pronostic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pronostic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pronostics/1
  # DELETE /pronostics/1.json
  def destroy
    @pronostic = Pronostic.find(params[:id])
    @pronostic.destroy

    respond_to do |format|
      format.html { redirect_to pronostics_url }
      format.json { head :no_content }
    end
  end

  def store_in_s3 (file_path, pronostic_id)

    service = S3::Service.new(:access_key_id => "AKIAJPVLATTZ3TYES3YQ",
                              :secret_access_key => "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")

    footibon_bucket = service.buckets.find(ENV['footibon_s3_bucket'])
    name=pronostic_id.to_s + ".jpg"

    new_object = footibon_bucket.objects.build(name)
    test=File.read(file_path, :encoding => "BINARY")
    new_object.content = test
    new_object.save
  end

  private

  def store_location
    if (params.has_key?("pronostic"))
      session[:pronostic_before_signin] = Pronostic.new(params["pronostic"])
      session[:user_return_to] = create_after_signin_pronostic_path
    end
  end

  def process_uri(uri)
    open(uri, :allow_redirections => :safe) do |r|
      r.base_uri.to_s
    end
  end

  def share_on_facebook pronostic
    user = FbGraph::User.me(current_user.fbtoken).fetch
    user.feed!(
        :message => pronostic.score_prono+', voici mon pronostic pour le match '+ pronostic.match.phrase + ". Qu'en penses-tu?",
        :picture => getAmazonLink + pronostic.id.to_s + ".jpg",
        :link => pronostic_url(pronostic),
        :name => user.name + ' pense que le match '+ pronostic.match.phrase + ' se terminera sur le score de '+pronostic.score1.to_s+'-'+pronostic.score2.to_s,
        :description => 'Toi aussi, défis tes amis et donne ton pronostic sur FootiBon !'
    )
  end

  def share_on_footibon_page_facebook pronostic
    owner_user = User.find_by_name("Gégé Mix")
    page = FbGraph::Page.new('FootiBon').fetch(
        :access_token => owner_user.fbtoken,
        :fields => :access_token
    )
    page.feed!(
        :message => pronostic.score_prono+', voici le pronostic de '+pronostic.user.name+' pour le match '+ pronostic.match.phrase + ". Qu'en penses-tu?",
        :picture => pronostic.url_s3,
        :link => pronostic_url(pronostic),
        :name => pronostic.user.name + " pense que le match "+ pronostic.match.phrase + " se terminera sur le score de "+pronostic.score1.to_s+"-"+pronostic.score2.to_s,
        :description => "Toi aussi, donne ton pronostic et défis tes amis et sur www.footibon.com! C\'est simple, rapide et fun !"
    )
  end
end
