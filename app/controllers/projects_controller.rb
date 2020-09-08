class ProjectsController < ApplicationController
  before_action :set_project, only: [:show]

  # GET /projects
  def index
    @user = User.find_by!(name: params[:user_name])

    if @user == current_user
      @projects = @user.projects
    else
      @projects = @user.published_projects
    end

    render json: @projects, scope: current_user
  end

  # GET /projects/1
  def show
    if @project.nil?
      render status: 403
    else
      render json: @project, include: [:words, :characters, :groups, :author], scope: current_user
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @user = User.find_by!(name: params[:user_name])
    project = @user.projects.find_by!(term_id: params[:term_id])

    if project.is_published || project.author == current_user
      @project = project
    else
      @project = nil
    end
  end
end
