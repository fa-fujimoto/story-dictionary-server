class CustomFolder < ApplicationRecord
  enum is_visible: { visible: true, invisible: false }
  PARAMS_LENGTH = Settings.model.params_length.custom_folder

  belongs_to :project

  has_many :attribute_items
  has_many :posts

  validates :term_id, :name, presence: true

  validates :term_id,
    format: { with: /\A[\w_]+\z/ },
    length: {
      in: PARAMS_LENGTH.term_id.min..PARAMS_LENGTH.term_id.max
    },
    uniqueness: { scope: :project_id }

  validates :name,
    length: {
      in: PARAMS_LENGTH.name.min..PARAMS_LENGTH.name.max
    },
    uniqueness: { scope: :project_id }

  validates :is_visible,
    inclusion: { in: CustomFolder.is_visibles.keys }

  scope :term_is, -> (id) { where(term_id: id) }
  scope :has_posts, -> { joins(:post) }

  def setable_for?(post)
    post.project == project
  end
end
