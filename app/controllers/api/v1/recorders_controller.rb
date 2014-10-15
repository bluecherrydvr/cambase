class Api::V1::RecordersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  swagger_controller :recorders, "Recorders Management"

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
    param :form, 'recorder[name]', :string, :required, "Name"
    param :form, 'recorder[model]', :string, :required, "Model"
    param_list :form, 'recorder[recorder_type]', :string, :optional, "Type", Recorder.uniq.pluck(:recorder_type).compact.sort
    param_list :form, 'recorder[resolution]', :string, :optional, "Resolution", Recorder.uniq.pluck(:resolution).compact.sort
    param_list :form, 'recorder[onvif]', :string, :optional, "ONVIF", [true, false]
    param_list :form, 'recorder[psia]', :string, :optional, "PSIA", [true, false]
    param_list :form, 'recorder[infrared]', :string, :optional, "Infrared", [true, false]
    param_list :form, 'recorder[playback_channels]', :integer, :optional, "Playback Channels"
    param_list :form, 'recorder[input_channels]', :integer, :optional, "Input Channels"
    param_list :form, 'recorder[upnp]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'recorder[audio_in]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'recorder[audio_out]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'recorder[discontinued]', :string, :optional, "Discontinued", [true, false]
    param_list :form, 'recorder[support_3rdparty]', :string, :optional, "3rd Party Cameras Support", [true, false]
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
    param :form, :vendor_id, :string, :required, "Vendor ID"
    param :form, 'recorder[name]', :string, :required, "Name"
    param :form, 'recorder[model]', :string, :required, "Model"
    param_list :form, 'recorder[recorder_type]', :string, :optional, "Type", Recorder.uniq.pluck(:recorder_type).compact.sort
    param_list :form, 'recorder[resolution]', :string, :optional, "Resolution", Recorder.uniq.pluck(:resolution).compact.sort
    param_list :form, 'recorder[onvif]', :string, :optional, "ONVIF", [true, false]
    param_list :form, 'recorder[psia]', :string, :optional, "PSIA", [true, false]
    param_list :form, 'recorder[ptz]', :string, :optional, "PTZ", [true, false]
    param_list :form, 'recorder[playback_channels]', :integer, :optional, "Playback Channels"
    param_list :form, 'recorder[input_channels]', :integer, :optional, "Input Channels"
    param_list :form, 'recorder[upnp]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'recorder[audio_in]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'recorder[audio_out]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'recorder[discontinued]', :string, :optional, "Discontinued", [true, false]
    param_list :form, 'recorder[support_3rdparty]', :string, :optional, "3rd Party Support", [true, false]
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
    param :query, 'q[recorder_cont]', :string, :optional, "Recorder"
    param :query, 'q[vendor_name_cont]', :string, :optional, "Vendor"
    param_list :query, 'q[recorder_type_eq]', :string, :optional, "Type", Recorder.uniq.pluck(:resolution).compact.sort
    param_list :query, 'q[resolution_eq]', :string, :optional, "Resolution", Recorder.uniq.pluck(:resolution).compact.sort
    param_list :query, 'q[onvif_true]', :string, :optional, "ONVIF", [true, false]
    param_list :query, 'q[psia_true]', :string, :optional, "PSIA", [true, false]
    param_list :query, 'q[ptz_true]', :string, :optional, "PTZ", [true, false]
    param_list :query, 'q[support_3rdparty_true]', :string, :optional, "3rd Party Support", [true, false]
    param_list :query, 'q[discontinued_true]', :string, :optional, "Discontinued", [true, false]
    param_list :query, 'q[sd_card_true]', :string, :optional, "SD Card", [true, false]
    param_list :query, 'q[upnp_true]', :string, :optional, "UPnP", [true, false]
    param_list :query, 'q[audio_in_true]', :string, :optional, "Audio In", [true, false]
    param_list :query, 'q[audio_out_true]', :string, :optional, "Audio Out", [true, false]
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

  def search
    @search = Recorder.search(params[:q])
    @recorders = @search.result.page params[:page]
    render :index
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
