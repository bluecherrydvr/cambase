class Api::V1::RecordersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  swagger_controller :recorders, "Recorders"

  swagger_api :index do
    summary "Fetches all Recorders"
    param :query, :page, :integer, :optional, "Page number"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Recorder"
    param :path, :id, :integer, :required, "Recorder ID"
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :create do
    summary "Creates a new Recorder"
    param :form, :vendor_id, :string, :required, "Vendor ID"
    param :form, 'recorder[model]', :string, :required, "Model"
    param :form, 'recorder[name]', :string, :required, "Name"
    param_list :form, 'recorder[recorder_type]', :string, :required, "Type", Recorder.uniq.pluck(:recorder_type).compact.sort
    param_list :form, 'recorder[resolution]', :string, :optional, "Resolution", Recorder.uniq.pluck(:resolution).compact.sort
    param_list :form, 'recorder[onvif]', :string, :optional, "ONVIF", [true, false]
    param_list :form, 'recorder[psia]', :string, :optional, "PSIA", [true, false]
    param_list :form, 'recorder[ptz]', :string, :optional, "PTZ", [true, false]
    param_list :form, 'recorder[discontinued]', :string, :optional, "Discontinued", [true, false]
    param_list :form, 'recorder[support_3rdparty]', :string, :optional, "3rd pparty Camera Support", [true, false]
    param_list :form, 'recorder[sd_card]', :string, :optional, "SD Card", [true, false]
    param_list :form, 'recorder[upnp]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'recorder[hot_swap]', :string, :optional, "Hot Swap", [true, false]
    param_list :form, 'recorder[hdmi]', :string, :optional, "HDMI Support", [true, false]
    param_list :form, 'recorder[digital_io]', :string, :optional, "Digital I/O", [true, false]
    param_list :form, 'recorder[audio_in]', :string, :optional, "Audio In", [true, false]
    param_list :form, 'recorder[audio_out]', :string, :optional, "Audio Out", [true, false]
    param_list :form, 'recorder[input_channels]', :string, :optional, "Input Channels", [1, 2, 4, 8, 16, 32, 64, 128, 2556]
    param_list :form, 'recorder[playback_channels]', :string, :optional, "Playback Channels", [1, 2, 4, 8, 16, 32, 64, 128, 2556]
    param_list :form, 'recorder[usb]', :string, :optional, "USB Ports"
    param_list :form, 'recorder[sdhc]', :string, :optional, "SD Card (GB)"
    param :form, 'recorder[mobile_access]', :string, :optional, "Mobile Access"
    param :form, 'recorder[alarms]', :string, :optional, "Alarms"
    param :form, 'recorder[raid_support]', :string, :optional, "Raid Support"
    param :form, 'recorder[storage]', :string, :optional, "Internal Storage"
    param :form, 'recorder[additional_information]', :string, :optional, "Additional Information"
    param :form, 'recorder[default_username]', :string, :optional, "Default Username"
    param :form, 'recorder[default_password]', :string, :optional, "Default Password"
    param :form, 'recorder[jpeg_url]', :string, :optional, "JPEG URL"
    param :form, 'recorder[h264_url]', :string, :optional, "H264 URL"
    param :form, 'recorder[mjpeg_url]', :string, :optional, "MJPEG URL"
    param :form, 'recorder[official_url]', :string, :optional, "Official URL"
    response :unauthorized
    response :not_acceptable
  end

  swagger_api :update do
    summary "Updates an existing Recorder"
    param :path, :id, :string, :required, "Recorder ID"
    param :form, :vendor_id, :string, :required, "Vendor ID"
    param :form, 'recorder[model]', :string, :required, "Model"
    param :form, 'recorder[name]', :string, :required, "Name"
    param_list :form, 'recorder[recorder_type]', :string, :required, "Type", Recorder.uniq.pluck(:recorder_type).compact.sort
    param_list :form, 'recorder[resolution]', :string, :optional, "Resolution", Recorder.uniq.pluck(:resolution).compact.sort
    param_list :form, 'recorder[onvif]', :string, :optional, "ONVIF", [true, false]
    param_list :form, 'recorder[psia]', :string, :optional, "PSIA", [true, false]
    param_list :form, 'recorder[ptz]', :string, :optional, "PTZ", [true, false]
    param_list :form, 'recorder[discontinued]', :string, :optional, "Discontinued", [true, false]
    param_list :form, 'recorder[support_3rdparty]', :string, :optional, "3rd pparty Camera Support", [true, false]
    param_list :form, 'recorder[sd_card]', :string, :optional, "SD Card", [true, false]
    param_list :form, 'recorder[upnp]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'recorder[hot_swap]', :string, :optional, "Hot Swap", [true, false]
    param_list :form, 'recorder[hdmi]', :string, :optional, "HDMI Support", [true, false]
    param_list :form, 'recorder[digital_io]', :string, :optional, "Digital I/O", [true, false]
    param_list :form, 'recorder[audio_in]', :string, :optional, "Audio In", [true, false]
    param_list :form, 'recorder[audio_out]', :string, :optional, "Audio Out", [true, false]
    param_list :form, 'recorder[input_channels]', :string, :optional, "Input Channels", [1, 2, 4, 8, 16, 32, 64, 128, 256]
    param_list :form, 'recorder[playback_channels]', :string, :optional, "Playback Channels", [1, 2, 4, 8, 16, 32, 64, 128, 256]
    param_list :form, 'recorder[usb]', :string, :optional, "USB Ports"
    param_list :form, 'recorder[sdhc]', :string, :optional, "SD Card (GB)"
    param :form, 'recorder[mobile_access]', :string, :optional, "Mobile Access"
    param :form, 'recorder[alarms]', :string, :optional, "Alarms"
    param :form, 'recorder[raid_support]', :string, :optional, "Raid Support"
    param :form, 'recorder[storage]', :string, :optional, "Internal Storage"
    param :form, 'recorder[additional_information]', :string, :optional, "Additional Information"
    param :form, 'recorder[default_username]', :string, :optional, "Default Username"
    param :form, 'recorder[default_password]', :string, :optional, "Default Password"
    param :form, 'recorder[jpeg_url]', :string, :optional, "JPEG URL"
    param :form, 'recorder[h264_url]', :string, :optional, "H264 URL"
    param :form, 'recorder[mjpeg_url]', :string, :optional, "MJPEG URL"
    param :form, 'recorder[official_url]', :string, :optional, "Official URL"
    response :unauthorized
    response :not_found
    response :not_acceptable
  end

  swagger_api :search do
    summary "Searches all Recorders"
    param :query, :page, :integer, :optional, "Page number"
    param :query, 'q[model_cont]', :string, :optional, "Model"
    param :query, 'q[vendor_name_cont]', :string, :optional, "Vendor"
    param :query, 'q[sdhc_eq]', :string, :optional, "SD Card (GB)"
    param_list :query, 'q[type_eq]', :string, :optional, "Type", Recorder.uniq.pluck(:recorder_type).compact.sort
    param_list :query, 'q[resolution_eq]', :string, :optional, "Resolution", Recorder.uniq.pluck(:resolution).compact.sort
    param_list :query, 'q[input_channels_eq]', :string, :optional, "Input Channels", [1, 2, 4, 8, 16, 32, 64, 128, 256]
    param_list :query, 'q[playback_channels_eq]', :string, :optional, "Playback Channels", [1, 2, 4, 8, 16, 32, 64, 128, 256]
    param_list :query, 'q[onvif_true]', :string, :optional, "ONVIF", [true, false]
    param_list :query, 'q[psia_true]', :string, :optional, "PSIA", [true, false]
    param_list :query, 'q[ptz_true]', :string, :optional, "PTZ", [true, false]
    param_list :query, 'q[usb_true]', :string, :optional, "USB", [true, false]
    param_list :query, 'q[sdhc_true]', :string, :optional, "SDHC", [true, false]
    param_list :query, 'q[sd_card_true]', :string, :optional, "SD Card", [true, false]
    param_list :query, 'q[upnp_true]', :string, :optional, "UPnP", [true, false]
    param_list :query, 'q[audio_in_true]', :string, :optional, "Audio In", [true, false]
    param_list :query, 'q[audio_out_true]', :string, :optional, "Audio Out", [true, false]
    param_list :query, 'q[hdmi_true]', :string, :optional, "HDMI Support", [true, false]
    param_list :query, 'q[hot_swap_true]', :string, :optional, "Hot Swap", [true, false]
    param_list :query, 'q[support_3rdparty_true]', :string, :optional, "3rd pparty Camera Support", [true, false]
    param_list :query, 'q[digital_io_true]', :string, :optional, "Digital I/O", [true, false]
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  def index
    valid_sort = ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    order = valid_sort.include?(params[:order]) ? params[:order] : 'created_at DESC'
    @recorders = Recorder.order(order).page params[:page]
  end

  def show
    @recorder = Recorder.find_by_recorder_slug(params[:id])
  end

  # def search
  #   @search = Recorder.search(params[:q])
  #   @recorders = @search.result.page params[:page]
  #   render :index
  # end

  def search
    @search = Recorder.search(params[:q])
    @recorders = @search.result.page params[:page]
    
    query = ""
    modelname = ""
    if params[:q] && params[:q]["model_cont"]
      recordername = params[:q]["model_cont"]
    end
    vendorname = ""
    if params[:q] && params[:q]["vendor_name_cont"]
      vendorname = params[:q]["vendor_name_cont"]
    end

    if modelname
      @recorder = Recorder.find_by_model(modelname)
      query = "recorder_slug LIKE ? ", "%#{modelname}%"
    end
    if vendorname
      @vendor = Vendor.find_by_vendor_slug(vendorname)
      if @vendor
        if modelname
          query = "model LIKE ? AND vendor_id = ?", "%#{modelname}%", @vendor.id
        else
          query = "vendor_id = ?", @vendor.id
        end
        @recorders = @recorders.where(query)
      end
      render :index
    else
      render :index
    end
  end

  def create
    params[:recorder][:vendor_id] = Vendor.find_by_vendor_slug(params[:vendor_id].to_url).id
    @recorder = Recorder.new(recorder_params)
    if @recorder.save
      render :show, status: :created
    else
      render json: @recorder.errors, status: :unprocessable_entity
    end
  end

  def update
    params[:vendor_id] = Vendor.find_by_vendor_slug(params[:vendor_id].to_url).id
    @recorder = Recorder.find_by_recorder_slug(params[:id])
    if @recorder.update(recorder_params)
      render :show, status: :created
    else
      render json: @recorder.errors, status: :unprocessable_entity
    end
  end

  def recorder_params
    params.require(:recorder).permit!
  end

end
