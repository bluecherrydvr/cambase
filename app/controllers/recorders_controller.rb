class RecordersController < ApplicationController
  before_action :set_recorder, only: [:show, :edit, :update, :destroy]

  # GET /recorders
  # GET /recorders.json
  def index
    if params[:q].blank?
      @search = Recorder.search()
      @recorders = Recorder.page params[:page]

      unless params[:vendor_slug].blank?
        @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug])
        @recorders = @recorders.where(:vendor_id => @vendor.id)
      end
    else
      @search = Recorder.search(params[:q])
      @recorders = @search.result.page params[:page]
    end
    
    respond_to do |format|
      format.html
      format.json { render :json => @recorders, :except => [:created_at, :updated_at] }
    end
  end

  def search
    index
    # render :index
  end

  def show
    unless params[:vendor_slug].blank?
      @vendor = Vendor.find_by_vendor_slug(params[:vendor_slug])
      @recorder = Recorder.where(:recorder_slug => params[:id]).where(:vendor_id => @vendor.id).first
    end
    respond_to do |format|
      format.html
      format.json {
        render :json =>
        @recorder
      }
    end
  end

  # GET /recorders/new
  def new
    @recorder = Recorder.new
  end

  # GET /recorders/1/edit
  def edit
  end

  # POST /recorders
  # POST /recorders.json
  def create
    @recorder = Recorder.new(recorder_params)
    respond_to do |format|
      if @recorder.save
        format.html {
          redirect_to vendor_recorder_path(@recorder.vendor.vendor_slug, @recorder.recorder_slug),
          notice: 'Recorder was successfully created.'
        }
        format.json { render :show, status: :created, location: @recorder }
      else
        format.html { redirect_to recorders_path, notice: @recorder.errors.full_messages.to_sentence }
        format.json { render json: @recorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recorders/1
  # PATCH/PUT /recorders/1.json
  def update
    @recorder = Recorder.find(params[:id])
    if params[:model][:images_attributes]
      @recorder.images.build(:file => params['model']['images_attributes']['0'][:file]).save
      params['model']['images_attributes'] = nil
    end
    respond_to do |format|
      if @recorder.update(recorder_params)
        format.html {
          redirect_to vendor_recorder_path(@recorder.vendor.vendor_slug, @recorder.recorder_slug),
          notice: 'Recorder was successfully updated.'
        }
        format.json { render json: @recorder }
      else
        format.html { redirect_to recorders_path, notice: @recorder.errors.full_messages.to_sentence }
        format.json { render json: @recorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recorders/1
  # DELETE /recorders/1.json
  def destroy
    @recorder.destroy
    respond_to do |format|
      format.html { redirect_to recorders_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recorder
    @recorder = Recorder.find_by_recorder_slug(params[:id])
  end

  def rollback_to_previous_version
    @recorder.versions.last.reify.save!
    flash[:notice] = "Your changes will be reflected once an admin has reviewed them"
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recorder_params
    params.require(:recorder).permit!.except(:id, :created_at, :updated_at)
  end
end
