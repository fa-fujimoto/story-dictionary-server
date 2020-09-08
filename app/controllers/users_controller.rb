class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /words
  def index
    @users = User.all

    render json: @users, scope: current_user
  end

  # GET /words/1
  def show
    render json: @user, include: [projects: [:author], following_projects: [:author], requesting_projects: [:author]], scope: current_user
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by!(name: params[:name])
  end
end
