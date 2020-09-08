class Project < ApplicationRecord
  has_paper_trail

  before_update :all_follow_request_approve

  enum commentable_status: {
    free: 0,
    followers_only: 1,
    editors_only: 2
  }, _prefix: true
  enum comment_viewable: {
    open: 0,
    followers_only: 1,
    editors_only: 2,
    hidden: -1
  }, _prefix: true
  enum comment_publish: {
    soon: 0,
    after_approval: 1,
    after_approval_only_for_guest: 2
  }, _prefix: true
  enum is_published: {
    published: true,
    protect: false
  }

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many :categories, dependent: :destroy
  has_many :word_categories, -> { kind_word.exists_posts }, class_name: :Category
  has_many :character_categories, -> { kind_character.exists_posts }, class_name: :Category
  has_many :group_categories, -> { kind_group.exists_posts }, class_name: :Category

  has_many :custom_folders, dependent: :destroy
  has_many :visible_custom_folders, -> { has_posts.visible }, class_name: :CustomFolder

  has_many :posts, dependent: :destroy

  has_many :attribute_configs, dependent: :destroy
  has_many :attribute_items, through: :attribute_configs, source: :item, dependent: :destroy

  has_many :words, -> { words }, class_name: 'Post'
  has_many :characters, -> { characters }, class_name: 'Post'
  has_many :groups, -> { groups }, class_name: 'Post'

  has_many :follower_viewable_words, -> { follower_viewable.words }, class_name: 'Post'
  has_many :follower_viewable_characters, -> { follower_viewable.characters }, class_name: 'Post'
  has_many :follower_viewable_groups, -> { follower_viewable.groups }, class_name: 'Post'

  has_many :published_words, -> { published.words }, class_name: 'Post'
  has_many :published_characters, -> { published.characters }, class_name: 'Post'
  has_many :published_groups, -> { published.groups }, class_name: 'Post'

  has_many :follow_statuses, class_name: :ProjectFollower, dependent: :destroy

  has_many :followed_users, -> { approved }, class_name: :ProjectFollower
  has_many :followers, through: :followed_users, source: :user

  has_many :follow_requests, -> { unapproved }, class_name: :ProjectFollower
  has_many :requesting_users, through: :follow_requests, source: :user

  PARAMS_LENGTH = Settings.model.params_length.project

  validates :term_id, presence: true,
    format: { with: /\A[\w_]+\z/ },
    length: {
      minimum: PARAMS_LENGTH.term_id.min,
      maximum: PARAMS_LENGTH.term_id.max
    },
    uniqueness: { scope: :author }
  validates :name, presence: true,
    length: {
      minimum: PARAMS_LENGTH.name.min,
      maximum: PARAMS_LENGTH.name.max
    }
  validates :kana, presence: true,
    format: { with: /\A[\p{hiragana}\w][\p{hiragana}ー、。・　\s\w]*\z/ },
    length: {
      minimum: PARAMS_LENGTH.kana.min,
      maximum: PARAMS_LENGTH.kana.max
    }
  validates :description,
    length: {
      minimum: PARAMS_LENGTH.description.min,
      maximum: PARAMS_LENGTH.description.max
    }

  def to_param
    term_id
  end

  def viewable?(user)
    published? || user == author || followed?(user)
  end

  def editable?(user)
    user == author || followed_users.exists?(user_id: user.id, permission: [:edit, :admin])
  end

  def followed?(user)
    user && followed_users.exists?(user_id: user.id)
  end

  def followable?(user)
    user != author && !follow_statuses.exists?(user_id: user.id)
  end

  def commentable_for?(user)
    if !comment_viewable_hidden? && viewable?(user)
      followed_permission = followed_permission_for(user)

      if followed_permission == 'admin'
        true
      else
        commentable_permission.include?(followed_permission)
      end
    end
  end

  def comment_viewable_for?(user)
    if !comment_viewable_hidden? && viewable?(user)
      followed_permission = followed_permission_for(user)

      if followed_permission == 'admin'
        true
      else
        comment_viewable_permission.include?(followed_permission)
      end
    end
  end

  def followed_permission_for(user)
    if user
      follow_status = follow_statuses.find_by(user_id: user.id)

      if follow_status
        follow_status.followed_permission
      elsif author == user
        'admin'
      else
        'guest'
      end
    else
      'guest'
    end
  end

  def request_approve_to(user)
    request = follow_requests.find_by(user_id: user.id)

    if request
      request.approved!
    end
  end

  def comment_release_soon?(user)
    user_permission = followed_permission_for(user)

    if comment_publish_after_approval?
      user_permission == 'admin'
    elsif comment_publish_after_approval_only_for_guest?
      ['admin', 'edit'].include? user_permission
    else
      commentable_permission.include? user_permission
    end
  end

  private
  def all_follow_request_approve
    if published? && will_save_change_to_is_published?
      follow_requests.map do |request|
        request.approved!
      end
    end
  end

  def comment_viewable_permission
    permission = ['admin', 'edit', 'view', 'requesting', 'guest']

    if protect? || comment_viewable_followers_only? || commentable_status_editors_only? || comment_viewable_editors_only?
      permission.delete('guest')
      permission.delete('requesting')
    end

    if comment_viewable_editors_only?
      permission.delete('view')
    end

    permission
  end

  def commentable_permission
    permission = comment_viewable_permission

    if commentable_status_followers_only?
      permission.delete('guest')
      permission.delete('requesting')
    end

    if commentable_status_editors_only?
      permission.delete('view')
    end

    permission
  end
end
