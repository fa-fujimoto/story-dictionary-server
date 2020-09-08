class CharacterDirectoriesController < ApplicationController
  before_action :set_directory, only: [:show, :update]

  # GET /directory
  def show
    if viewable?
      render json: @directory
    else
      render status: 403
    end
  end

  # PATCH/PUT /directory
  def update
    if @project.author == current_user
      if @directory.update(directory_params)
        render json: @directory
      else
        render json: @directory.errors, status: :unprocessable_entity
      end
    else
      render status: 403
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_directory
      @project = Project.find(params[:project_id])
      @directory = @project.character_directory
    end

    # Only allow a trusted parameter "white list" through.
    def directory_params
      params.require(:character_directory).permit(:is_published, :is_editable)
    end

    def viewable?
      ( @project.is_published && @directory.is_published ) || @project.author == current_user
    end
end
