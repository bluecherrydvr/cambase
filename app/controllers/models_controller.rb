class ModelsController < ApplicationController
  before_action :set_model, only: [:show, :edit, :update, :destroy]

  def models_data
    # condition = "lower(vendor_models.name) like lower('%#{params[:vendor_model]}%') AND
    #             lower(jpg_url) like lower('%#{params[:snapshot_url]}%') AND
    #             lower(h264_url) like lower('%#{params[:h264_url]}%') AND
    #             lower(mjpg_url) like lower('%#{params[:mjpg_url]}%')"
    # dash_vendors_models = DashVendorModel.joins(:vendor).where(condition).where("lower(vendors.name) like lower('%#{params[:vendor]}%')")

    if params[:q].blank?
      if params[:vendor_slug].blank?
        @models_list = Model.all
      else
        @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug].to_url)
        @models_list = Model.where(:vendor_id => @vendor.id)
      end
    else
      if !params[:q][:vendor_id_eq].blank?
        @vendor = Vendor.find(params[:q][:vendor_id_eq])
      end
      if params[:vendor_slug].blank?
        @models_list = Model.all
      else
        @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug].to_url)
        @models_list = Model.where(:vendor_id => @vendor.id)
      end
      @search = Model.search(params[:q])
      @models_list = @search.result.all
    end

    if params[:order]
      case params[:order]["0"]["column"]
      when "0"
        @order_by = ""
      when "1"
        @order_by = "model " + params[:order]["0"]["dir"].upcase
      when "2"
        @order_by = "vendor_id " + params[:order]["0"]["dir"].upcase
      when "3"
        @order_by = "resolution " + params[:order]["0"]["dir"].upcase
      when "4"
        @order_by = "shape " + params[:order]["0"]["dir"].upcase
      when "5"
        @order_by = "psia " + params[:order]["0"]["dir"].upcase
      when "6"
        @order_by = "ptz " + params[:order]["0"]["dir"].upcase
      when "7"
        @order_by = "infrared " + params[:order]["0"]["dir"].upcase
      else
        @order_by = ""
      end
    end

    @models_list = @models_list.order(@order_by)

    total_records = @models_list.count
    display_length = params[:length].to_i
    display_length = display_length < 0 ? total_records : display_length
    display_start = params[:start].to_i
    table_draw = params[:draw].to_i

    index_end = display_start + display_length
    index_end = index_end > total_records ? total_records - 1 : index_end
    records = {:data => [], :draw => table_draw, :recordsTotal => total_records, :recordsFiltered => total_records}

    (display_start..index_end).each do |index|
      @model = @models_list[index]
      @vendor = Vendor.find(@model.vendor_id)
      if !@model.images.empty?
        @image_tag = view_context.image_tag(
          @model.images.sorted.first.file.url(:small), 
          class: 'align-center',
          data: { fullsize: @model.images.sorted.first.file.url(:small) }
        )
      end
      @link_to_model = view_context.link_to @model.model, "/vendors/#{@model.vendor.vendor_slug}/models/#{@model.model_slug}"
      @link_to_vendor = view_context.link_to @model.vendor.name, "/vendors/#{@model.vendor.vendor_slug}/models"
      if Model::SHAPES.include? @model.shape.downcase
        @shape = "<span class='icon-camera_shape_#{@model.shape.downcase}' title='#{@model.shape.titleize}'></span>"
      else
        @shape = @model.shape.titleize
      end
      if @model.onvif?
        @onvif = "<span class='dot' title='Onvif'></span>"
      end
      if @model.psia?
        @psia = "<span class='dot' title='PSIA'></span>"
      end
      if @model.ptz?
        @ptz = "<span class='dot' title='PTZ'></span>"
      end
      if @model.infrared?
        @infrared = "<span class='dot' title='Infrared'></span>"
      end
      if @model.sd_card?
        @sd_card = "<span class='dot' title='SD Card'></span>"
      end
      if @model.upnp?
        @upnp = "<span class='dot' title='UPnP'></span>"
      end
      if @model.discontinued?
        @discontinued = "<span class='dot' title='Discontinued'></span>"
      end
      if @model.audio_in?
        @audio_in = "<span class='dot' title='Audio In'></span>"
      end
      if @model.audio_out?
        @audio_out = "<span class='dot' title='Audio Out'></span>"
      end
      if @model.poe?
        @poe = "<span class='dot' title='PoE'></span>"
      end
      if @model.wifi?
        @wifi = "<span class='dot' title='WiFi'></span>"
      end
      records[:data][records[:data].count] = [
        @image_tag,
        @link_to_model,
        @link_to_vendor,
        @model.resolution,
        @shape,
        @onvif,
        @psia,
        @ptz,
        @infrared,
        @varifocal,
        @sd_card,
        @upnp,
        @discontinued,
        @audio_in,
        @audio_out,
        @poe,
        @wifi
      ]
    end
    render json: records
  end

  # GET /models
  # GET /models.json
  def index
    if params[:q].blank?

      if params[:vendor_slug].blank?
        @vendor = Vendor.first
        @models = Model.where(:vendor_id => @vendor.id)
      else
        @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug].to_url)
        @models = Model.where(:vendor_id => @vendor.id)
      end
    else
      if !params[:q][:vendor_id_eq].blank?
        @vendor = Vendor.find(params[:q][:vendor_id_eq])
      end
      @search = Model.search(params[:q])
      @models = @search.result.all
    end

    respond_to do |format|
      format.html
      format.json { render :json => @models, :except => [:created_at, :updated_at] }
    end
  end

  def search
    index
  end

  # GET /models/1
  # GET /models/1.json
  def show
    unless params[:vendor_slug].blank?
      @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug].to_url)
      @model = Model.where(:model_slug => params[:id]).where(:vendor_id => @vendor.id).first
      # fix blank URLs to '/' for all ACTi cameras 
      if @vendor.name.downcase == "acti" #&& @model.model.downcase.start_with?('acm')
        if @model.jpeg_url && (@model.jpeg_url.downcase == "<blank>" || @model.jpeg_url.downcase == "" || @model.jpeg_url.downcase == "f")
          @model.jpeg_url = '/'
        end
        if @model.h264_url && (@model.h264_url.downcase == "<blank>" || @model.h264_url.downcase == "" || @model.h264_url.downcase == "f")
          @model.h264_url = '/'
        end
        if @model.mjpeg_url && (@model.mjpeg_url.downcase == "<blank>" || @model.mjpeg_url.downcase == "" || @model.mjpeg_url.downcase == "f")
          @model.mjpeg_url = '/'
        end
        if @model.official_url && (@model.official_url.downcase == "<blank>" || @model.official_url.downcase == "" || @model.official_url.downcase == "f")
          @model.official_url = '/'
        end
        if @model.manual_url && (@model.manual_url.downcase == "<blank>" || @model.manual_url.downcase == "" || @model.manual_url.downcase == "f")
          @model.manual_url = '/'
        end
      end
    end
    respond_to do |format|
      format.html
      format.json {
        render :json =>
        @model
      }
    end
  end

  # GET /models/new
  def new
    @model = Model.new
  end

  # GET /models/1/edit
  def edit
  end

  # POST /models
  # POST /models.json
  def create
    @model = Model.new(model_params)
    respond_to do |format|
      if @model.save
        format.html {
          redirect_to vendor_model_path(@model.vendor.vendor_slug, @model.model_slug),
          notice: 'Model was successfully created.'
        }
        format.json { render :show, status: :created, location: @model }
      else
        format.html { redirect_to models_path, notice: @model.errors.full_messages.to_sentence }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /models/1
  # PATCH/PUT /models/1.json
  def update
    @model = Model.find(params[:id])
    if params[:model][:images_attributes]
      @model.images.build(:file => params['model']['images_attributes']['0'][:file]).save
      params['model']['images_attributes'] = nil
    end
    respond_to do |format|
      if @model.update(model_params)
        format.html {
          redirect_to vendor_model_path(@model.vendor.vendor_slug, @model.model_slug),
          notice: 'Model was successfully updated.'
        }
        format.json { render json: @model }
      else
        format.html { redirect_to models_path, notice: @model.errors.full_messages.to_sentence }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
    @model.destroy
    respond_to do |format|
      format.html { redirect_to models_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_model
    @model = Model.find_by_model_slug(params[:id])
  end

  def rollback_to_previous_version
    @model.versions.last.reify.save!
    flash[:notice] = "Your changes will be reflected once an admin has reviewed them"
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def model_params
    params.require(:model).permit!.except(:id, :created_at, :updated_at)
  end

end
