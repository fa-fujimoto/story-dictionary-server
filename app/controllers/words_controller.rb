class WordsController < ApplicationController
  before_action :set_project
  before_action :set_words
  before_action :set_word, only: [:show]

  # GET /projects/1/words
  def index
    if @words.nil?
      render status: 403
    else
      render json: @words, each_serializer: WordSerializer, include: [:category]
    end
  end

  # GET /projects/1/words/1
  def show
    if @word.nil?
      render status: 403
    else
      render json: @word, serializer: WordSerializer, include: [:category, :author, :last_editor, :attr, :comments], detail: true
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find_by!(term_id: params[:project_term_id])
  end

  def set_words
    if @project.viewable?(current_user)
      if @project.followed?(current_user)
        @words = @project.follower_viewable_words
      else
        @words = @project.published_words
      end
    else
      @words = nil
    end
  end

  def set_word
    if @words.nil?
      @word = nil
    else
      @word = @words.find_by(term_id: params[:term_id])
    end
  end
end
