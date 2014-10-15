class ModelsController < ApplicationController
  before_action :set_model, only: [:show, :edit, :update, :destroy]

  # GET /models
  # GET /models.json
  def index
    if params[:q].blank?
      @search = Model.search()
      @models = Model.page params[:page]

      unless params[:vendor_slug].blank?
        @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug])
        @models = @models.where(:vendor_id => @vendor.id)
      end
    else
      @search = Model.search(params[:q])
      @models = @search.result.page params[:page]
    end
    respond_to do |format|
      format.html
      format.json { render :json => @models, :except => [:created_at, :updated_at] }
    end
  end

  def search
    index
    # render :index
  end

  # GET /models/1
  # GET /models/1.json
  def show
    unless params[:vendor_slug].blank?
      @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug])
      @model = Model.where(:model_slug => params[:id]).where(:vendor_id => @vendor.id).first
    end
    respond_to do |format|
      format.html
      format.json {
        render :json =>
        @model
      }
    end
  end

  # GET /models/new
  def new
    @model = Model.new
  end

  # GET /models/1/edit
  def edit
  end

  # POST /models
  # POST /models.json
  def create
    @model = Model.new(model_params)
    respond_to do |format|
      if @model.save
        format.html {
          redirect_to vendor_model_path(@model.vendor.vendor_slug, @model.model_slug),
          notice: 'Model was successfully created.'
        }
        format.json { render :show, status: :created, location: @model }
      else
        format.html { redirect_to models_path, notice: @model.errors.full_messages.to_sentence }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /models/1
  # PATCH/PUT /models/1.json
  def update
    @model = Model.find(params[:id])
    if params[:model][:images_attributes]
      @model.images.build(:file => params['model']['images_attributes']['0'][:file]).save
      params['model']['images_attributes'] = nil
    end
    respond_to do |format|
      if @model.update(model_params)
        format.html {
          redirect_to vendor_model_path(@model.vendor.vendor_slug, @model.model_slug),
          notice: 'Model was successfully updated.'
        }
        format.json { render json: @model }
      else
        format.html { redirect_to models_path, notice: @model.errors.full_messages.to_sentence }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
    @model.destroy
    respond_to do |format|
      format.html { redirect_to models_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_model
    @model = Model.find_by_model_slug(params[:id])
  end

  def rollback_to_previous_version
    @model.versions.last.reify.save!
    flash[:notice] = "Your changes will be reflected once an admin has reviewed them"
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def model_params
    params.require(:model).permit!.except(:id, :created_at, :updated_at)
  end
end
