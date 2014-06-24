class EquipesController < ApplicationController

  before_filter :only_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET /equipes
  # GET /equipes.json
  def index
    @equipes = Equipe.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @equipes }
    end
  end

  # GET /equipes/1
  # GET /equipes/1.json
  def show
    @equipe = Equipe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @equipe }
    end
  end

  # GET /equipes/new
  # GET /equipes/new.json
  def new
    @equipe = Equipe.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @equipe }
    end
  end

  # GET /equipes/1/edit
  def edit
    @equipe = Equipe.find(params[:id])
  end

  # POST /equipes
  # POST /equipes.json
  def create
    @equipe = Equipe.new(params[:equipe])

    respond_to do |format|
      if @equipe.save
        format.html { redirect_to @equipe, notice: 'Equipe was successfully created.' }
        format.json { render json: @equipe, status: :created, location: @equipe }
      else
        format.html { render action: "new" }
        format.json { render json: @equipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /equipes/1
  # PUT /equipes/1.json
  def update
    @equipe = Equipe.find(params[:id])

    respond_to do |format|
      if @equipe.update_attributes(params[:equipe])
        format.html { redirect_to @equipe, notice: 'Equipe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @equipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipes/1
  # DELETE /equipes/1.json
  def destroy
    @equipe = Equipe.find(params[:id])
    @equipe.destroy

    respond_to do |format|
      format.html { redirect_to equipes_url }
      format.json { head :no_content }
    end
  end
end
