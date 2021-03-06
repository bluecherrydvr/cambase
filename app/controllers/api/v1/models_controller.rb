class Api::V1::ModelsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  swagger_controller :models, "Models"

  swagger_api :index do
    summary "Fetches all Models"
    param :query, :page, :integer, :optional, "Page number"
    param_list :query, :order, :string, :optional, "Sort order", ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  swagger_api :show do
    summary "Fetches a single Model"
    param :path, :id, :integer, :required, "Model ID"
    response :unauthorized
    response :not_acceptable
    response :not_found
  end

  swagger_api :create do
    summary "Creates a new Model"
    param :form, :vendor_id, :string, :required, "Vendor ID"
    param :form, 'model[model]', :string, :required, "Model"
    param_list :form, 'model[shape]', :string, :optional, "Shape", Model.uniq.pluck(:shape).compact.sort
    param_list :form, 'model[resolution]', :string, :optional, "Resolution", Model.uniq.pluck(:resolution).compact.sort
    param_list :form, 'model[onvif]', :string, :optional, "ONVIF", [true, false]
    param_list :form, 'model[psia]', :string, :optional, "PSIA", [true, false]
    param_list :form, 'model[ptz]', :string, :optional, "PTZ", [true, false]
    param_list :form, 'model[infrared]', :string, :optional, "Infrared", [true, false]
    param_list :form, 'model[varifocal]', :string, :optional, "Varifocal", [true, false]
    param_list :form, 'model[sd_card]', :string, :optional, "SD Card", [true, false]
    param_list :form, 'model[upnp]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'model[audio_in]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'model[audio_out]', :string, :optional, "UPnP", [true, false]
    param :form, 'model[default_username]', :string, :optional, "Default Username"
    param :form, 'model[default_password]', :string, :optional, "Default Password"
    param :form, 'model[jpeg_url]', :string, :optional, "JPEG URL"
    param :form, 'model[h264_url]', :string, :optional, "H264 URL"
    param :form, 'model[mjpeg_url]', :string, :optional, "MJPEG URL"
    response :unauthorized
    response :not_acceptable
  end

  swagger_api :update do
    summary "Updates an existing Model"
    param :path, :id, :string, :required, "Model ID"
    param :form, :vendor_id, :string, :required, "Vendor ID"
    param :form, 'model[model]', :string, :optional, "Model"
    param_list :form, 'model[shape]', :string, :optional, "Shape", Model.uniq.pluck(:shape).compact.sort
    param_list :form, 'model[resolution]', :string, :optional, "Resolution", Model.uniq.pluck(:resolution).compact.sort
    param_list :form, 'model[onvif]', :string, :optional, "ONVIF", [true, false]
    param_list :form, 'model[psia]', :string, :optional, "PSIA", [true, false]
    param_list :form, 'model[ptz]', :string, :optional, "PTZ", [true, false]
    param_list :form, 'model[infrared]', :string, :optional, "Infrared", [true, false]
    param_list :form, 'model[varifocal]', :string, :optional, "Varifocal", [true, false]
    param_list :form, 'model[sd_card]', :string, :optional, "SD Card", [true, false]
    param_list :form, 'model[upnp]', :string, :optional, "UPnP", [true, false]
    param_list :form, 'model[audio_in]', :string, :optional, "Audio In", [true, false]
    param_list :form, 'model[audio_out]', :string, :optional, "Audio Out", [true, false]
    param :form, 'model[default_username]', :string, :optional, "Default Username"
    param :form, 'model[default_password]', :string, :optional, "Default Password"
    param :form, 'model[jpeg_url]', :string, :optional, "JPEG URL"
    param :form, 'model[h264_url]', :string, :optional, "H264 URL"
    param :form, 'model[mjpeg_url]', :string, :optional, "MJPEG URL"
    response :unauthorized
    response :not_found
    response :not_acceptable
  end

  swagger_api :search do
    summary "Searches all Models"
    param :query, :page, :integer, :optional, "Page number"
    param :query, 'q[model_cont]', :string, :optional, "Model"
    param :query, 'q[manufacturer_name_cont]', :string, :optional, "Vendor"
    param_list :query, 'q[shape_eq]', :string, :optional, "Shape", Model.uniq.pluck(:shape).compact.sort
    param_list :query, 'q[resolution_eq]', :string, :optional, "Resolution", Model.uniq.pluck(:resolution).compact.sort
    param_list :query, 'q[onvif_true]', :string, :optional, "ONVIF", [true, false]
    param_list :query, 'q[psia_true]', :string, :optional, "PSIA", [true, false]
    param_list :query, 'q[ptz_true]', :string, :optional, "PTZ", [true, false]
    param_list :query, 'q[infrared_true]', :string, :optional, "Infrared", [true, false]
    param_list :query, 'q[varifocal_true]', :string, :optional, "Varifocal", [true, false]
    param_list :query, 'q[sd_card_true]', :string, :optional, "SD Card", [true, false]
    param_list :query, 'q[upnp_true]', :string, :optional, "UPnP", [true, false]
    param_list :query, 'q[audio_in_true]', :string, :optional, "Audio In", [true, false]
    param_list :query, 'q[audio_out_true]', :string, :optional, "Audio Out", [true, false]
    response :unauthorized
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
  end

  def index
    valid_sort = ['created_at DESC', 'created_at ASC', 'updated_at DESC', 'updated_at ASC']
    order = valid_sort.include?(params[:order]) ? params[:order] : 'created_at DESC'
    @models = Model.order(order).page params[:page]
  end

  def show
    @model = Model.find_by_model_slug(params[:id].downcase)
  end

  def search
    @search = Model.search(params[:q])
    @models = @search.result.page params[:page]
    
    query = ""
    modelname = ""
    if params[:q] && params[:q]["model_cont"]
      modelname = params[:q]["model_cont"]
    end
    vendorname = ""
    if params[:q] && params[:q]["manufacturer_name_cont"]
      vendorname = params[:q]["manufacturer_name_cont"]
    end
    
    if modelname
      @model = Model.find_by_model_slug(modelname)
      query = "model_slug LIKE ? ", "%#{modelname}%"
    end
    if vendorname
      @vendor = Vendor.find_by_vendor_slug(vendorname)
      if @vendor
        if modelname
          query = "model_slug LIKE ? AND vendor_id = ?", "%#{modelname}%", @vendor.id
        else
          query = "vendor_id = ?", @vendor.id
        end
        @models = @models.where(query)
      end
      render :index
    else
      render :index
    end
  end

  def create
    params[:model][:vendor_id] = Vendor.find_by_vendor_slug(params[:vendor_id].to_url).id
    @model = Model.new(model_params)
    if @model.save
      render :show, status: :created
    else
      render json: @model.errors, status: :unprocessable_entity
    end
  end

  def update
    params[:vendor_id] = Vendor.find_by_vendor_slug(params[:vendor_id].to_url).id
    @model = Model.find_by_model_slug(params[:id].downcase)
    if @model.update(model_params)
      render :show, status: :created
    else
      render json: @model.errors, status: :unprocessable_entity
    end
  end

  def model_params
    params.require(:model).permit!
  end

end
