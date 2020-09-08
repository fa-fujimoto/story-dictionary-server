class Category < ApplicationRecord
  PARAMS_LENGTH = Settings.model.params_length.category

  enum kind: {
    word: 0,
    character: 1,
    group: 2,
    custom: 99
  }, _prefix: true

  belongs_to :project
  has_many :posts

  validates :term_id,
    presence: true,
    length: {
      minimum: PARAMS_LENGTH.term_id.min,
      maximum: PARAMS_LENGTH.term_id.max
    },
    uniqueness: { scope: [:project_id] }
  validates :name,
    presence: true,
    length: {
      minimum: PARAMS_LENGTH.name.min,
      maximum: PARAMS_LENGTH.name.max
    },
    uniqueness: { scope: [:project_id, :kind] }
  validates :synopsis,
    length: {
      minimum: PARAMS_LENGTH.synopsis.min,
      maximum: PARAMS_LENGTH.synopsis.max,
      allow_blank: true
    }
  validates :body,
    length: {
      minimum: PARAMS_LENGTH.body.min,
      maximum: PARAMS_LENGTH.body.max,
      allow_blank: true
    }
  validates :kind,
    inclusion: { in: Category.kinds.keys }

  scope :type_is, -> (name) { where(kind: name) }
  scope :exists_posts, -> { joins(:posts) }

  def setable_for?(post)
    post.kind == kind && post.project == project
  end
end
