module Api
  module V1
    class CamerasController < ApplicationController
      def index
        @cameras = Camera.all
      end
      def show
        @camera = Camera.find(params[:id])
      end
    end
  end
end


class Api::V1::CamerasController < ApplicationController

  swagger_controller :cameras, "Camera Management"

  swagger_api :index do
    summary "Fetches all Camera items"
    param :query, :page, :integer, :optional, "Page number(not implemented yet)"
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Camera item"
    param :path, :id, :integer, :required, "Camera Id"
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  def index
    @cameras = Camera.all
  end
  def show
    @camera = Camera.find(params[:id])
  end

end
