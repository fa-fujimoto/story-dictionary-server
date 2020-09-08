class DictionariesController < ApplicationController
  before_action :set_dictionary, only: [:show, :update]

  # GET /dictionary
  def show
    if ( @project.is_published && @dictionary.is_published ) || @project.author == current_user
      render json: @dictionary
    else
      render status: 403
    end
  end

  # PATCH/PUT /dictionary
  def update
    if @project.author == current_user
      if @dictionary.update(dictionary_params)
        render json: @dictionary
      else
        render json: @dictionary.errors, status: :unprocessable_entity
      end
    else
      render status: 403
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dictionary
      @project = Project.find(params[:project_id])
      @dictionary = @project.dictionary
    end

    # Only allow a trusted parameter "white list" through.
    def dictionary_params
      params.require(:dictionary).permit(:is_published, :is_editable)
    end

    def viewable?
      ( @project.is_published && @dictionary.is_published ) || @project.author == current_user
    end
end
