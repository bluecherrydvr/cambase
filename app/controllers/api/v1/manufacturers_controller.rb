class Api::V1::ManufacturersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  swagger_controller :manufacturers, "Manufacturers"

  swagger_api :index do
    summary "Fetches all Manufacturers"
    param :query, :page, :integer, :optional, "Page number"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Manufacturer"
    param :path, :id, :string, :required, "Manufacturer ID"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :create do
    summary "Creates a new Manufacturer"
    param :form, 'manufacturer[name]', :string, :required, "Name"
    param :form, 'manufacturer[url]', :string, :required, "Website"
    response :unauthorized
    response :not_acceptable
  end

  swagger_api :update do
    summary "Updates an existing Manufacturer"
    param :path, :id, :string, :required, "Manufacturer ID"
    param :form, 'manufacturer[name]', :string, :optional, "Name"
    param :form, 'manufacturer[url]', :string, :optional, "Website"
    response :unauthorized
    response :not_found
    response :not_acceptable
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

  def create
    @manufacturer = Manufacturer.new(manufacturer_params)
    if @manufacturer.save
      render json: @manufacturer
    else
      render json: @manufacturer.errors, status: :unprocessable_entity
    end
  end

  def update
    @manufacturer = Manufacturer.find_by_manufacturer_slug(params[:id])
    if @manufacturer.update(manufacturer_params)
      render json: @manufacturer
    else
      render json: @manufacturer.errors, status: :unprocessable_entity
    end
  end

  def manufacturer_params
    params.require(:manufacturer).permit!
  end

end
