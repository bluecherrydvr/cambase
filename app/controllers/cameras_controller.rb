class CamerasController < ApplicationController
  before_action :set_camera, only: [:show, :edit, :update, :destroy]

  # GET /cameras
  # GET /cameras.json
  def index
    if params[:q].blank?
      @search = Camera.search()
      @cameras = Camera.page params[:page]
    else
      @search = Camera.search(params[:q])
      @cameras = @search.result.page params[:page]
    end
    respond_to do |format|
      format.html
      format.json { render :json => @cameras, :except => [:created_at, :updated_at] }
    end
  end

  def search
    index
    # render :index
  end

  # GET /cameras/1
  # GET /cameras/1.json
  def show
    # @camera = Camera.find(params[:id])
    respond_to do |format|
      format.html
      format.json {
        render :json =>
        @camera
      }
    end
  end

  # GET /cameras/new
  def new
    @camera = Camera.new
  end

  # GET /cameras/1/edit
  def edit
  end

  # POST /cameras
  # POST /cameras.json
  def create
    @camera = Camera.new(camera_params)

    respond_to do |format|
      if @camera.save
        format.html { redirect_to @camera, notice: 'Camera was successfully created.' }
        format.json { render :show, status: :created, location: @camera }
      else
        format.html { render :new }
        format.json { render json: @camera.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cameras/1
  # PATCH/PUT /cameras/1.json
  def update
    respond_to do |format|
      if @camera.update(camera_params)
        format.html { redirect_to @camera, notice: 'Camera was successfully updated.' }
        format.json { render :show, status: :ok, location: @camera }
      else
        format.html { render :edit }
        format.json { render json: @camera.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cameras/1
  # DELETE /cameras/1.json
  def destroy
    @camera.destroy
    respond_to do |format|
      format.html { redirect_to cameras_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_camera
    @camera = Camera.find_by_camera_slug(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def camera_params
    params.require(:camera).permit(:model,
                                   :manufacturer_id,
                                   :shape,
                                   :manual_url,
                                   :jpeg_url,
                                   :h264_url,
                                   :mjpeg_url,
                                   :resolution,
                                   :firmware,
                                   :credentials,
                                   Camera::FEATURES,
                                   :image, images_attributes: [:id, :file, :_destroy])
  end
end
