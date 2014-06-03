class Api::V1::CamerasController < ApplicationController
  swagger_controller :cameras, "Camera Management"

  swagger_api :index do
    summary "Fetches all Camera items"
    param :query, :page, :integer, :optional, "Page number"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Camera item"
    param :path, :id, :integer, :required, "Camera ID"
    response :unauthorized
    response :not_acceptable
    response :not_found
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
