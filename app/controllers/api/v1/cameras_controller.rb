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
