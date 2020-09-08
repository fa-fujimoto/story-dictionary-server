class ProjectSerializer < ApplicationSerializer
  attributes :term_id, :name, :kana, :description, :is_published, :is_author, :is_followed, :permission, :created_at, :updated_at, :followers_count
  belongs_to :author
  has_many :custom_folders

  has_many :words
  has_many :characters
  has_many :groups

  def posts_serialize posts, kind
    categories = posts.left_joins(:category).group(:category_id).pluck("categories.name, categories.term_id, count(posts.id)")

    categories_info = categories.map do |category|
      {
        name: category[0],
        term_id: category[1],
        count: category[2]
      }
    end

    {
      count: posts.count,
      posts: posts.map {|post| PostSerializer.new(post)},
      kind: kind,
      categories: categories_info
    }
  end

  def words
    posts = is_followed || is_author ? object.follower_viewable_words : object.published_words
    posts_serialize posts, 'word'
  end

  def characters
    posts = is_followed || is_author ? object.follower_viewable_characters : object.published_characters
    posts_serialize posts, 'character'
  end

  def groups
    posts = is_followed || is_author ? object.follower_viewable_groups : object.published_groups
    posts_serialize posts, 'group'
  end

  def custom_folders
    object.visible_custom_folders.map do |folder|
      folder.posts.count
    end
  end

  def is_followed
    object.followed? current_user
  end

  def permission
    object.followed_permission_for current_user
  end

  def is_author
    object.author == current_user
  end

  def followers_count
    object.followers.count
  end

  class PostSerializer < ApplicationSerializer
    attributes :term_id, :name, :kana, :synopsis, :created_at, :updated_at, :kind
    def kind
      object.kind
    end
  end
end
