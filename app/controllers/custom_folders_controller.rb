class CustomFoldersController < ApplicationController
  before_action :set_custom_folder, only: [:show, :update, :destroy]

  # GET /custom_folders
  def index
    @custom_folders = CustomFolder.all

    render json: @custom_folders
  end

  # GET /custom_folders/1
  def show
    render json: @custom_folder
  end

  # POST /custom_folders
  def create
    @custom_folder = CustomFolder.new(custom_folder_params)

    if @custom_folder.save
      render json: @custom_folder, status: :created, location: @custom_folder
    else
      render json: @custom_folder.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /custom_folders/1
  def update
    if @custom_folder.update(custom_folder_params)
      render json: @custom_folder
    else
      render json: @custom_folder.errors, status: :unprocessable_entity
    end
  end

  # DELETE /custom_folders/1
  def destroy
    @custom_folder.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_folder
      @custom_folder = CustomFolder.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def custom_folder_params
      params.require(:custom_folder).permit(:term_id, :name, :is_visible, :project_id)
    end
end
