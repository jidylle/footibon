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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pronostic }
    end
  end

  # GET /pronostics/new
  # GET /pronostics/new.json
  def new
    @pronostic = Pronostic.new

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

    respond_to do |format|
      if @pronostic.save
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
end
