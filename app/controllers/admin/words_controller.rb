class Admin::WordsController < Admin::Base
  before_action :set_project
  before_action :set_word, only: [:show, :update, :versions, :autosave]

  # GET /account/projects/1/words
  def index
    @words = @project.words

    render json: @words, include: []
  end

  # POST /account/projects/1/words/1
  def create
    @word = Word.new(word_params)
    @word.project = @project
    @word.author = @account
    @word.last_editor = @account

    if @word.save
      render json: @word, status: :created
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  # POST /account/projects/1
  def update
    @word.last_editor = @account
    if @word.update(word_params)
      render json: @word
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  # DELETE /account/projects/1
  def destroy
    @word.destroy
  end

  # GET /account/projects/1/words/1/versions
  def versions
    render json: @word.versions
  end

  # POST /account/projects/1/words/1/autosave
  def autosave
    @draft = @word.draft.authored.first
    if @draft
      @draft = WordDraft.new(draftParams)
      @draft.word = @word

      if @draft.save
        render json: @draft, status: :created
      else
        render json: @draft.errors, status: :unprocessable_entity
      end
    else
      if @draft.update(word_params)
        render json: @draft
      else
        render json: @draft.errors, status: :unprocessable_entity
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = @account.projects.find_by!(term_id: params[:project_term_id])
    end

    def set_word
      @word = @project.words.find_by!(term_id: params[:term_id])
    end

    # Only allow a trusted parameter "white list" through.
    def word_params
      params.require(:word).permit(:term_id, :name, :kana, :synopsis, :body, :is_published, :is_draft)
    end

    # Only allow a trusted parameter "white list" through.
    def draft_word
      params.require(:word).permit(:term_id, :name, :kana, :synopsis, :body, :is_published)
    end
end