class Api::V1::ManufacturersController < ApplicationController

  swagger_controller :manufacturers, "Manufacturers"

  swagger_api :index do
    summary "Fetches all Manufacturer items"
    param :query, :page, :integer, :optional, "Page number"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Manufacturer item"
    param :path, :id, :string, :required, "Manufacturer ID"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  def index
    valid_sort = ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    order = valid_sort.include?(params[:order]) ? params[:order] : 'created_at DESC'
    @manufacturers = Manufacturer.order(order).page params[:page]
  end

  def show
    valid_sort = ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    order = valid_sort.include?(params[:order]) ? params[:order] : 'created_at DESC'
    @manufacturer = Manufacturer.find_by_manufacturer_slug(params[:id])
    @cameras = @manufacturer.cameras.order(order).page params[:page]
  end

end
