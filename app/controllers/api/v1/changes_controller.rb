class Api::V1::ChangesController < ApplicationController

  swagger_controller :changes, "Changes"

  swagger_api :index do
    summary "Fetches all Changes"
    param :query, :page, :integer, :optional, "Page number"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Change"
    param :path, :id, :string, :required, "Change ID"
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  def index
    valid_sort = ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    order = valid_sort.include?(params[:order]) ? params[:order] : 'created_at DESC'
    @changes = PaperTrail::Version.order(order).page params[:page]
  end

  def show
    valid_sort = ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    order = valid_sort.include?(params[:order]) ? params[:order] : 'created_at DESC'
    @change = PaperTrail::Version.find(params[:id])
  end

end
