class Api::V1::CamerasController < ApplicationController
  skip_before_filter :verify_authenticity_token

  swagger_controller :cameras, "Camera Management"

  swagger_api :index do
    summary "Fetches all Cameras"
    param :query, :page, :integer, :optional, "Page number"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Camera"
    param :path, :id, :integer, :required, "Camera ID"
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :create do
    summary "Creates a new Camera"
    param :form, :manufacturer_id, :string, :required, "Manufacturer ID"
    param :form, 'camera[model]', :string, :required, "Model"
    param_list :form, 'camera[shape]', :string, :optional, "Shape", Camera::SHAPES
    param_list :form, 'camera[resolution]', :string, :optional, "Resolution", Camera.uniq.pluck(:resolution).compact.sort
    param_list :form, 'camera[onvif]', :string, :optional, "ONVIF", [true, false]
    param_list :form, 'camera[psia]', :string, :optional, "PSIA", [true, false]
    param_list :form, 'camera[ptz]', :string, :optional, "PTZ", [true, false]
    param_list :form, 'camera[infrared]', :string, :optional, "Infrared", [true, false]
    param_list :form, 'camera[varifocal]', :string, :optional, "Varifocal", [true, false]
    param_list :form, 'camera[sd_card]', :string, :optional, "SD Card", [true, false]
    param_list :form, 'camera[upnp]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'camera[audio_in]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'camera[audio_out]', :string, :optional, "UPnP", [true, false]
    param :form, 'camera[default_username]', :string, :optional, "Default Username"
    param :form, 'camera[default_password]', :string, :optional, "Default Password"
    param :form, 'camera[jpeg_url]', :string, :optional, "JPEG URL"
    param :form, 'camera[h264_url]', :string, :optional, "H264 URL"
    param :form, 'camera[mjpeg_url]', :string, :optional, "MJPEG URL"
    response :unauthorized
    response :not_acceptable
  end

  swagger_api :update do
    summary "Updates an existing Camera"
    param :path, :id, :string, :required, "Camera ID"
    param :form, :manufacturer_id, :string, :required, "Manufacturer ID"
    param :form, 'camera[name]', :string, :optional, "Model"
    param_list :form, 'camera[shape]', :string, :optional, "Shape", Camera::SHAPES
    param_list :form, 'camera[resolution]', :string, :optional, "Resolution", Camera.uniq.pluck(:resolution).compact.sort
    param_list :form, 'camera[onvif]', :string, :optional, "ONVIF", [true, false]
    param_list :form, 'camera[psia]', :string, :optional, "PSIA", [true, false]
    param_list :form, 'camera[ptz]', :string, :optional, "PTZ", [true, false]
    param_list :form, 'camera[infrared]', :string, :optional, "Infrared", [true, false]
    param_list :form, 'camera[varifocal]', :string, :optional, "Varifocal", [true, false]
    param_list :form, 'camera[sd_card]', :string, :optional, "SD Card", [true, false]
    param_list :form, 'camera[upnp]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'camera[audio_in]', :string, :optional, "Audio In", [true, false]
    param_list :form, 'camera[audio_out]', :string, :optional, "Audio Out", [true, false]
    param :form, 'camera[default_username]', :string, :optional, "Default Username"
    param :form, 'camera[default_password]', :string, :optional, "Default Password"
    param :form, 'camera[jpeg_url]', :string, :optional, "JPEG URL"
    param :form, 'camera[h264_url]', :string, :optional, "H264 URL"
    param :form, 'camera[mjpeg_url]', :string, :optional, "MJPEG URL"
    response :unauthorized
    response :not_found
    response :not_acceptable
  end

  swagger_api :search do
    summary "Searches all Cameras"
    param :query, :page, :integer, :optional, "Page number"
    param :query, 'q[model_cont]', :string, :optional, "Model"
    param :query, 'q[manufacturer_name_cont]', :string, :optional, "Manufacturer"
    param_list :query, 'q[shape_eq]', :string, :optional, "Shape", Camera::SHAPES
    param_list :query, 'q[resolution_eq]', :string, :optional, "Resolution", Camera.uniq.pluck(:resolution).compact.sort
    param_list :query, 'q[onvif_true]', :string, :optional, "ONVIF", [true, false]
    param_list :query, 'q[psia_true]', :string, :optional, "PSIA", [true, false]
    param_list :query, 'q[ptz_true]', :string, :optional, "PTZ", [true, false]
    param_list :query, 'q[infrared_true]', :string, :optional, "Infrared", [true, false]
    param_list :query, 'q[varifocal_true]', :string, :optional, "Varifocal", [true, false]
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
    @cameras = Camera.order(order).page params[:page]
  end

  def show
    @camera = Camera.find_by_camera_slug(params[:id])
  end

  def search
    @search = Camera.search(params[:q])
    @cameras = @search.result.page params[:page]
    render :index
  end

  def create
    params[:camera][:manufacturer_id] = Manufacturer.find_by_manufacturer_slug(params[:manufacturer_id].to_url).id
    @camera = Camera.new(camera_params)
    if @camera.save
      render :show, status: :created
    else
      render json: @camera.errors, status: :unprocessable_entity
    end
  end

  def update
    params[:manufacturer_id] = Manufacturer.find_by_manufacturer_slug(params[:manufacturer_id].to_url).id
    @camera = Camera.find_by_camera_slug(params[:id])
    if @camera.update(camera_params)
      render :show, status: :created
    else
      render json: @camera.errors, status: :unprocessable_entity
    end
  end

  def camera_params
    params.require(:camera).permit!
  end

end
