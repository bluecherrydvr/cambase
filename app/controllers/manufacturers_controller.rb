class ManufacturersController < ApplicationController
  before_action :set_manufacturer, only: [:show, :edit, :update, :destroy]

  # GET /manufacturers
  # GET /manufacturers.json
  def index
    @manufacturers = Manufacturer.order(:name).page params[:page]
    respond_to do |format|
      format.html
      format.json {
        render :json =>
        @manufacturers,
        :include => {:cameras => { :except => [:created_at, :updated_at] }},
        :except => [:created_at, :updated_at]
      }
    end
  end

  # GET /manufacturers/1
  # GET /manufacturers/1.json
  def show
    @manufacturers = Manufacturer.find_by_manufacturer_slug(params[:id])
    @cameras = Manufacturer.find_by_manufacturer_slug(params[:id]).cameras.order(:model).page params[:page]
    respond_to do |format|
      format.html
      format.json { render :json => @cameras, :except => [:created_at, :updated_at] }
    end
  end

  # GET /manufacturers/new
  def new
    @manufacturer = Manufacturer.new
    @manufacturer.build_image
  end

  # GET /manufacturers/1/edit
  def edit
  end

  # POST /manufacturers
  # POST /manufacturers.json
  def create
    @manufacturer = Manufacturer.new(manufacturer_params)
    respond_to do |format|
      if @manufacturer.save
        format.html { redirect_to "/#{@manufacturer.manufacturer_slug}", notice: 'Manufacturer was successfully created.' }
        format.json { render :show, status: :created, location: @manufacturer }
      else
        format.html { redirect_to manufacturers_path, notice: @manufacturer.errors.full_messages.to_sentence  }

        format.json { render json: @manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manufacturers/1
  # PATCH/PUT /manufacturers/1.json
  def update
    @manufacturer = Manufacturer.find(params[:id])
    respond_to do |format|
      if @manufacturer.update(manufacturer_params)
        format.html { redirect_to "/#{@manufacturer.manufacturer_slug}", notice: 'Manufacturer was successfully updated.' }
        format.json { render json: @manufacturer }
      else
        format.html { redirect_to manufacturers_path, notice: @manufacturer.errors.full_messages.to_sentence }
        format.json { render json: @manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.json
  def destroy
    @manufacturer.destroy
    respond_to do |format|
      format.html { redirect_to manufacturers_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_manufacturer
    @manufacturer = Manufacturer.find_by_manufacturer_slug(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def manufacturer_params
    params.require(:manufacturer).permit(:name, :image, :url, image_attributes: [:id, :file, :_destroy])
  end
end
