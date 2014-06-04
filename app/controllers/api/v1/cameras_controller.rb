class Api::V1::CamerasController < ApplicationController
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

  swagger_api :search do
    summary "Searches all Cameras"
    param :query, :page, :integer, :optional, "Page number"
    param :query, 'q[model_cont]', :string, :optional, "Manufacturer"
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

end
