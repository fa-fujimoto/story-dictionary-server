class UserSerializer < ApplicationSerializer
  attributes :name, :nickname, :image, :is_myself

  has_many :projects, serializer: ProjectSerializer, include: [:author], curent_user: :current_user, root: false
  has_many :following_projects, serializer: ProjectSerializer, include: [:author], curent_user: :current_user, root: false
  has_many :requesting_projects, serializer: ProjectSerializer, include: [:author], curent_user: :current_user, root: false, if: :myself?

  def projects
    myself? ? object.projects : object.published_projects
  end

  def following_projects
    myself? ? object.following_projects : object.published_following_projects
  end

  def is_myself
    myself?
  end

  def myself?
    current_user == object
  end
end
