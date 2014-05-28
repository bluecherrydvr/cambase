class Api::V1::ManufacturersController < ApplicationController

  end

  def index
    @manufacturers = Manufacturer.all
  end

  def show
    @manufacturer = Manufacturer.find_by_manufacturer_slug(params[:id])
    @cameras = @manufacturer.cameras.page params[:page]
  end

end
