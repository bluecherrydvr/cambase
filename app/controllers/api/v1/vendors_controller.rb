class Api::V1::VendorsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  swagger_controller :vendors, "Vendors"

  swagger_api :index do
    summary "Fetches all Vendors"
    param :query, :page, :integer, :optional, "Page number"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Vendor"
    param :path, :id, :string, :required, "Vendor ID"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :create do
    summary "Creates a new Vendor"
    param :form, 'vendor[name]', :string, :required, "Name"
    param :form, 'vendor[info]', :string, :optional, "Info."
    param :form, 'vendor[url]', :string, :optional, "Website"
    param :form, 'vendor[mac]', :string, :optional, "MAC"
    response :unauthorized
    response :not_acceptable
  end

  swagger_api :update do
    summary "Updates an existing Vendor"
    param :path, :id, :string, :required, "Vendor ID"
    param :form, 'vendor[name]', :string, :optional, "Name"
    param :form, 'vendor[info]', :string, :optional, "Info."
    param :form, 'vendor[url]', :string, :optional, "Website"
    param :form, 'vendor[mac]', :string, :optional, "MAC"
    response :unauthorized
    response :not_found
    response :not_acceptable
  end

  def index
    valid_sort = ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    order = valid_sort.include?(params[:order]) ? params[:order] : 'created_at DESC'
    @vendors = Vendor.order(order).page params[:page]
  end

  def show
    valid_sort = ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    order = valid_sort.include?(params[:order]) ? params[:order] : 'created_at DESC'
    @vendor = Vendor.find_by_vendor_slug(params[:id])
    @models = @vendor.models.order(order).page params[:page]
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      render json: @vendor
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  def update
    @vendor = Vendor.find_by_vendor_slug(params[:id])
    if @vendor.update(vendor_params)
      render json: @vendor
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  def vendor_params
    params.require(:vendor).permit!
  end

end
