class Post < ApplicationRecord
  before_validation :set_default_value
  has_paper_trail
  PARAMS_LENGTH = Settings.model.params_length.post

  enum status: { deleted: -1, published: 0, protect: 1, draft: 2, requesting: 3 }
  enum disclosure_range: { followers_only: 0, editors_only: 1, administrators_only: 2 }, _prefix: true

  before_validation :set_last_editor, on: :create

  has_one :word, dependent: :destroy
  has_one :character, dependent: :destroy
  has_one :group, dependent: :destroy
  has_one :custom, class_name: 'CustomPost', dependent: :destroy

  has_many :attribute_values, dependent: :destroy
  has_many :attribute_items, through: :attribute_values, source: :item

  has_many :visible_attribute_values, -> (post) { has_value.visible_for(post.kind) }, class_name: :AttributeValue

  has_many :relations_from, class_name: :PostRelation, foreign_key: 'from_id', inverse_of: :from, dependent: :destroy
  has_many :relations_to, class_name: :PostRelation, foreign_key: 'to_id', inverse_of: :to, dependent: :destroy
  has_many :relationing, through: :relations_from, source: :to
  has_many :relationed, through: :relations_to, source: :from

  has_many :comments, dependent: :destroy

  belongs_to :project
  belongs_to :category, optional: true
  belongs_to :custom_folder, optional: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :last_editor, class_name: 'User', foreign_key: 'last_editor_id', optional: true

  accepts_nested_attributes_for :word, limit: 1, allow_destroy: true
  accepts_nested_attributes_for :group, limit: 1, allow_destroy: true
  accepts_nested_attributes_for :character, limit: 1, allow_destroy: true
  accepts_nested_attributes_for :custom, limit: 1, allow_destroy: true
  accepts_nested_attributes_for :attribute_values, allow_destroy: true


  validates :term_id, presence: true,
    format: { with: /\A[\w]+\z/ },
    length: {
      minimum: PARAMS_LENGTH.term_id.min,
      maximum: PARAMS_LENGTH.term_id.max
    },
    uniqueness: { scope: :project_id }

  validates :name, presence: true,
    length: {
      minimum: PARAMS_LENGTH.name.min,
      maximum: PARAMS_LENGTH.name.max
    },
    uniqueness: { scope: [:word, :character, :group, :custom] }

  validates :kana,
    format: { with: /\A[\p{hiragana}\w][\p{hiragana}ー、。・　\s\w]*\z/, allow_blank: true },
    length: {
      minimum: PARAMS_LENGTH.kana.min,
      maximum: PARAMS_LENGTH.kana.max
    }
  validates :synopsis,
    length: {
      minimum: PARAMS_LENGTH.synopsis.min,
      maximum: PARAMS_LENGTH.synopsis.max,
    },
    allow_blank: true

  validates :status,
    inclusion: { in: Post.statuses.keys }

  validates_inclusion_of :disclosure_range,
    # in: Post.disclosure_ranges.keys,
    in: ['followers_only'],
    if: :protect?

  validates_absence_of :disclosure_range,
    unless: :protect?

  validates :custom_folder_id,
    presence: { if: :custom },
    absence: { unless: :custom }

  validate :required_post_child
  validate :check_name_uniqueness
  validate :check_category
  validate :check_custom_folder

  scope :editor_only, -> { where.not(status: :draft) }

  scope :follower_viewable, -> { where(status: [:published, :protect]) }

  scope :words, -> { joins(:word) }
  scope :characters, -> { joins(:character) }
  scope :groups, -> { joins(:group) }
  scope :customs_as, -> (term_id) { joins(:custom_folder).where(custom_folders: { term_id: term_id }) }

  def to_param
    term_id
  end

  def kind
    if word.present?
      'word'
    elsif character.present?
      'character'
    elsif group.present?
      'group'
    elsif custom.present?
      'custom'
    end
  end

  def setable_attribute?(attr)
    attr && attr.projects.exists?(id: project.id) && post.kind == attr.post_type
  end

  def settable_post_for?(post)
    post && post.project == project
  end

  def viewable_for?(user)
    if project.viewable?(user)
      permission = project.followed_permission_for(user)

      if ['admin', 'edit'].include?(permission) && user_id == user.id
        permission = 'author'
      end

      viewable_permission.include?(permission)
    end
  end

  def replyable_for?(user)
    project.commentable_for?(user) && viewable_for?(user)
  end

  def exist_name?
    if word.present?
      project && project.posts.words.exists?(name: name)
    elsif character.present?
      project && project.posts.characters.exists?(name: name)
    elsif group.present?
      project && project.posts.groups.exists?(name: name)
    elsif custom.present?
      custom_folder && custom_folder.posts.exists?(name: name)
    end
  end

  def comment_release_soon?(user)
    project && project.comment_release_soon?(user)
  end

  private
  def required_post_child
    unless word.present? ^ character.present? ^ group.present? ^ custom.present?
      errors.add(:base, 'post child is only')
    end
  end

  def check_name_uniqueness
    if project && exist_name?
      errors.add(:name, :invalid)
    end
  end

  def check_category
    if category && !category.setable_for?(self)
      errors.add(:category, :invalid)
    end
  end

  def check_custom_folder
    if custom_folder && !custom_folder.setable_for?(self)
      errors.add(:custom_folder, :invalid)
    end
  end

  def set_last_editor
    if last_editor.nil?
      self.last_editor = author
    end
  end

  def viewable_permission
    if published?
      permission = ['admin', 'edit', 'view', 'requesting', 'guest', 'author']
    elsif protect?
      permission = ['admin', 'edit', 'view', 'author']
    elsif draft?
      permission = ['author']
    elsif requesting?
      permission = ['admin', 'author']
    elsif deleted?
      permission = ['admin', 'edit', 'author']
    end
  end

  def set_default_value
    if protect? && disclosure_range.nil?
      self.disclosure_range = 'followers_only'
    end
  end
end
