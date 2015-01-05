class RecordersController < ApplicationController
  before_action :set_recorder, only: [:show, :edit, :update, :destroy]

  def recorders_data
    if params[:q].blank?
      if params[:vendor_slug].blank?
        @recorders_list = Recorder.all
      else
        @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug].to_url)
        @recorders_list = Recorder.where(:vendor_id => @vendor.id)
      end
    else
      if !params[:q][:vendor_id_eq].blank?
        @vendor = Vendor.find(params[:q][:vendor_id_eq])
      end
      if params[:vendor_slug].blank?
        @recorders_list = Recorder.all
      else
        @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug].to_url)
        @recorders_list = Recorder.where(:vendor_id => @vendor.id)
      end
      @search = Recorder.search(params[:q])
      @recorders_list = @search.result.all
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
        @order_by = "recorder_type " + params[:order]["0"]["dir"].upcase
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

    @recorders_list = @recorders_list.order(@order_by)

    total_records = @recorders_list.count
    display_length = params[:length].to_i
    display_length = display_length < 0 ? total_records : display_length
    display_start = params[:start].to_i
    table_draw = params[:draw].to_i

    index_end = display_start + display_length
    index_end = index_end > total_records ? total_records - 1 : index_end
    records = {:data => [], :draw => table_draw, :recordsTotal => total_records, :recordsFiltered => total_records}

    (display_start..index_end).each do |index|
      @recorder = @recorders_list[index]
      @vendor = Vendor.find(@recorder.vendor_id)
      if !@recorder.images.empty?
        @image_tag = view_context.image_tag(
          @recorder.images.sorted.first.file.url(:small), 
          class: 'align-center',
          data: { fullsize: @recorder.images.sorted.first.file.url(:small) }
        )
      end
      @link_to_recorder = view_context.link_to @recorder.model, "/vendors/#{@recorder.vendor.vendor_slug}/recorders/#{@recorder.recorder_slug}"
      @link_to_vendor = view_context.link_to @recorder.vendor.name, "/vendors/#{@recorder.vendor.vendor_slug}/recorders"
      if Recorder::TYPES.include? @recorder.recorder_type.downcase
        @shape = "<span class='icon-camera_shape_#{@recorder.recorder_type.upcase}' title='#{@recorder.recorder_type.upcase}'></span>"
      else
        @shape = @recorder.recorder_type.upcase
      end
      if @recorder.onvif?
        @onvif = "<span class='dot' title='Onvif'></span>"
      end
      if @recorder.psia?
        @psia = "<span class='dot' title='PSIA'></span>"
      end
      if @recorder.ptz?
        @ptz = "<span class='dot' title='PTZ'></span>"
      end
      if @recorder.hdmi?
        @hdmi = "<span class='dot' title='HDMI'></span>"
      end
      if @recorder.digital_io?
        @digital_io = "<span class='dot' title='Digital IO'></span>"
      end
      if @recorder.upnp?
        @upnp = "<span class='dot' title='UPnP'></span>"
      end
      if @recorder.discontinued?
        @discontinued = "<span class='dot' title='Discontinued'></span>"
      end
      if @recorder.audio_in?
        @audio_in = "<span class='dot' title='Audio In'></span>"
      end
      if @recorder.audio_out?
        @audio_out = "<span class='dot' title='Audio Out'></span>"
      end
      if @recorder.hot_swap?
        @hot_swap = "<span class='dot' title='Hot Swap'></span>"
      end
      if @recorder.support_3rdparty?
        @support_3rdparty = "<span class='dot' title='3rd Party Support'></span>"
      end
      records[:data][records[:data].count] = [
        @image_tag,
        @link_to_recorder,
        @link_to_vendor,
        @recorder.resolution,
        @shape,
        @onvif,
        @psia,
        @ptz,
        @hdmi,
        @digital_io,
        @sd_card,
        @upnp,
        @discontinued,
        @audio_in,
        @audio_out,
        @hot_swap,
        @support_3rdparty
      ]
    end
    render json: records
  end

  # GET /recorders
  # GET /recorders.json
  def index
    if params[:q].blank?
      @search = Recorder.search()
      if params[:vendor_slug].blank?
        @recorder = Recorder.first
        if @recorder
          @vendor = Vendor.find(@recorder.vendor_id)
        else
          @vendor = Vendor.first
        end
        @recorders = Recorder.where(:vendor_id => @vendor.id)
      else
        @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug].to_url)
        @recorders = Recorder.where(:vendor_id => @vendor.id)
      end
    else
      if !params[:q][:vendor_id_eq].blank?
        @vendor = Vendor.find(params[:q][:vendor_id_eq])
      end
      @search = Recorder.search(params[:q])
      @recorders = @search.result.all
    end
    
    respond_to do |format|
      format.html
      format.json { render :json => @recorders, :except => [:created_at, :updated_at] }
    end
  end

  def search
    index
  end

  # GET /recorders/1
  # GET /recorders/1.json
  def show
    unless params[:vendor_slug].blank?
      @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug].to_url)
      @recorder = Recorder.where(:recorder_slug => params[:id]).where(:vendor_id => @vendor.id).first
    end
    respond_to do |format|
      format.html
      format.json {
        render :json =>
        @recorder
      }
    end
  end

  # GET /recorders/new
  def new
    @recorder = Recorder.new
  end

  # GET /recorders/1/edit
  def edit
  end

  # POST /recorders
  # POST /recorders.json
  def create
    @recorder = Recorder.new(recorder_params)
    respond_to do |format|
      if @recorder.save
        format.html {
          redirect_to vendor_recorder_path(@recorder.vendor.vendor_slug, @recorder.recorder_slug),
          notice: 'Recorder was successfully created.'
        }
        format.json { render :show, status: :created, location: @recorder }
      else
        format.html { redirect_to recorders_path, notice: @recorder.errors.full_messages.to_sentence }
        format.json { render json: @recorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recorders/1
  # PATCH/PUT /recorders/1.json
  def update
    @recorder = Recorder.find(params[:id])
    if params[:model][:images_attributes]
      @recorder.images.build(:file => params['model']['images_attributes']['0'][:file]).save
      params['model']['images_attributes'] = nil
    end
    respond_to do |format|
      if @recorder.update(recorder_params)
        format.html {
          redirect_to vendor_recorder_path(@recorder.vendor.vendor_slug, @recorder.recorder_slug),
          notice: 'Recorder was successfully updated.'
        }
        format.json { render json: @recorder }
      else
        format.html { redirect_to recorders_path, notice: @recorder.errors.full_messages.to_sentence }
        format.json { render json: @recorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recorders/1
  # DELETE /recorders/1.json
  def destroy
    @recorder.destroy
    respond_to do |format|
      format.html { redirect_to recorders_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recorder
    @recorder = Recorder.find_by_recorder_slug(params[:id])
  end

  def rollback_to_previous_version
    @recorder.versions.last.reify.save!
    flash[:notice] = "Your changes will be reflected once an admin has reviewed them"
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recorder_params
    params.require(:recorder).permit!.except(:id, :created_at, :updated_at)
  end
end
