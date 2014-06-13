class PronosticsController < ApplicationController

  # GET /pronostics
  # GET /pronostics.json
  def index
    @pronostics = Pronostic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pronostics }
    end
  end

  # GET /pronostics/1
  # GET /pronostics/1.json
  def show

    @pronostic = Pronostic.find(params[:id])
    @url_s3_pronostic="http://mqtechbucketus.s3.amazonaws.com/"+@pronostic.id.to_s+".jpg"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pronostic }
    end
  end

  # GET /pronostics/new
  # GET /pronostics/new.json
  def new
    @match =Match.find(params["match_id"])
    @pronostic = Pronostic.new
    @pronostic.match=@match

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
    @pronostic = Pronostic.new(params[:pronostic])

    first_image = MiniMagick::Image.open "#{Rails.root}/app/assets/images/scoreboard.jpg"



    equipe1 = MiniMagick::Image.open @pronostic.match.equipe1.drapeau
    equipe1.resize "114x80!"
    equipe2 = MiniMagick::Image.open @pronostic.match.equipe2.drapeau
    equipe2.resize "114x80!"
    result = first_image.composite(equipe1) do |c|
      c.compose "Over" # OverCompositeOp
      c.geometry "+285+325" # copy second_image onto first_image from (20, 20)
    end
    result = result.composite(equipe2) do |c|
      c.compose "Over" # OverCompositeOp
      c.geometry "+585+325" # copy second_image onto first_image from (20, 20)
    end

    result.combine_options do |c|
      c.font "#{Rails.root}/public/signika-bold.ttf"
      c.pointsize '30'
      c.draw "text 290,310 '#{@pronostic.match.equipe1.nom}'"
      c.draw "text 590,310 '#{@pronostic.match.equipe2.nom}'"
      c.pointsize '120'
      c.draw "text 310,280 '#{@pronostic.score1}'"
      c.draw "text 610,280 '#{@pronostic.score2}'"
      c.fill("#ffffff")
    end

    file_tmp_path="#{Rails.root}/tmp/output.jpg"
    result.write file_tmp_path



    respond_to do |format|
      if @pronostic.save
        store_in_s3(file_tmp_path, @pronostic.id)
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

    mqtech_bucket = service.buckets.find("mqtechbucketus")
    name=pronostic_id.to_s + ".jpg"

    new_object = mqtech_bucket.objects.build(name)
    test=File.read(file_path, :encoding => "BINARY")
    new_object.content = test
    new_object.save
  end
end
