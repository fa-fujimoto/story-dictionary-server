module Directory
  extend ActiveSupport::Concern

  included do
    belongs_to :project

    validates :is_published, :is_editable,
      inclusion: { in: [true, false] }
    validates :project, presence: { on: :create }
    validates :project_id, presence: { on: :update },
      uniqueness: { allow_blank: true }

    scope :published, -> { where(is_published: true) }

    def viewable?(user)
      ( is_published && project.is_published ) || user == project.author
    end
  end
end