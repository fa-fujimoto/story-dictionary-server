class CharactersController < ApplicationController
  before_action :set_directory
  before_action :set_character, only: [:show, :update, :destroy]

  # GET /characters
  def index
    if @directory.nil?
      render status: 403
    else
      render json: @characters
    end
  end

  # GET /characters/1
  def show
    if @character.nil?
      render status: 403
    else
      render json: @character
    end
  end

  # POST /characters
  def create
    if @is_author
      @character = Character.new(character_params)
      @character.directory = @directory

      if @character.save
        render json: @character, status: :created, location: project_character_directory_character_url(@project, @character)
      else
        render json: @character.errors, status: :unprocessable_entity
      end
    else
      render status: 403
    end
  end

  # PATCH/PUT /characters/1
  def update
    if @is_author
      if @character.update(character_params)
        render json: @character
      else
        render json: @character.errors, status: :unprocessable_entity
      end
    else
      render status: 403
    end
  end

  # DELETE /characters/1
  def destroy
    if @is_author
      @character.destroy
    else
      render status: 403
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_directory
      @project = Project.find(params[:project_id])
      @directory = @project.character_directory

      @is_author = @project.author == current_user

      if @is_author
        @characters = @directory.characters
      elsif @project.is_published && @directory.is_published
        @characters = @directory.published_characters
      else
        @directory = nil
        @characters = nil
      end
    end

    def set_character
      if @directory.nil?
        @character = nil
      else
        # @character = @charcters.find_by(id: params[:id])
        @character = @characters.find_by(id: params[:id])
      end
    end

    # Only allow a trusted parameter "white list" through.
    def character_params
      params.require(:character).permit(:term_id, :name, :kana, :is_published, :synopsis, :body, :directory)
    end
end
