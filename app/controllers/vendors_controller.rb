class VendorsController < ApplicationController
  before_action :set_vendor, only: [:show, :edit, :update, :destroy]

  # GET /vendors
  # GET /vendors.json
  def index
    @vendors = Vendor.order(:name).all
    respond_to do |format|
      format.html
      format.json {
        render :json =>
        @vendors,
        :include => {:models => { :except => [:created_at, :updated_at] }},
        :except => [:created_at, :updated_at]
      }
    end
  end

  # GET /vendors/1
  # GET /vendors/1.json
  def show
    @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug])
    if !@vendor
      raise ActionController::RoutingError.new('Not Found')
    end
    @models = Model.includes(:vendor, :images).where(:vendor_id => @vendor.id).references(:images)
    @recorders = Recorder.includes(:vendor, :images).where(:vendor_id => @vendor.id).references(:images)
    respond_to do |format|
      format.html
      format.json { render :json }
    end
  end

  # GET /vendors/new
  def new
    @vendor = Vendor.new
    @vendor.build_image
  end

  # GET /vendors/1/edit
  def edit
  end

  # POST /vendors
  # POST /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)
    respond_to do |format|
      if @vendor.save
        format.html { redirect_to "/#{@vendor.vendor_slug}", notice: 'Vendor was successfully created.' }
        format.json { render :show, status: :created, location: @vendor }
      else
        format.html { redirect_to vendors_path, notice: @vendor.errors.full_messages.to_sentence  }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendors/1
  # PATCH/PUT /vendors/1.json
  def update
    @vendor = Vendor.find(params[:id])
    if params[:vendor][:image_attributes]
      params[:vendor][:image_attributes][:id] = nil
    end
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to "/#{@vendor.vendor_slug}", notice: 'Vendor was successfully updated.' }
        format.json { render json: @vendor }
      else
        format.html { redirect_to vendors_path, notice: @vendor.errors.full_messages.to_sentence }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.json
  def destroy
    @vendor.destroy
    respond_to do |format|
      format.html { redirect_to vendors_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_vendor
    @vendor = Vendor.find_by_vendor_slug(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def vendor_params
    params.require(:vendor).permit(:name, :image, :url, image_attributes: [:id, :file, :_destroy])
  end
end
