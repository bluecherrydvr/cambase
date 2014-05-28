class Api::V1::ManufacturersController < ApplicationController

  swagger_controller :manufacturers, "Manufacturers"

  swagger_api :index do
    summary "Fetches all Manufacturer items"
    param :query, :page, :integer, :optional, "Page number"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Manufacturer item"
    param :path, :id, :string, :required, "Manufacturer ID"
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  def index
    @manufacturers = Manufacturer.all
  end

  def show
    @manufacturer = Manufacturer.find_by_manufacturer_slug(params[:id])
    @cameras = @manufacturer.cameras.page params[:page]
  end

end
