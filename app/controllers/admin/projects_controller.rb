class Admin::ProjectsController < Admin::Base
  before_action :set_project, only: [:show, :update, :destory]

  # GET /account/projects
  def index
    @projects = @account.projects

    render json: @projects, include: []
  end

  # POST /account/projects
  def create
    @project = Project.new(project_params)
    @project.author = @account

    if @project.save
      render json: @project, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # POST /account/projects/1
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /account/projects/1
  def destroy
    @project.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = @account.projects.find_by!(term_id: params[:term_id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:term_id, :name, :kana, :description, :is_published, :synopsis)
    end
end