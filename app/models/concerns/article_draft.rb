module ArticleDraft
  extend ActiveSupport::Concern

  included do
    belongs_to :author, class_name: 'User', foreign_key: 'user_id'

    validates :is_published,
      inclusion: {in: [true, false]}

    scope :authored, -> (user_id) { where(user_id: user_id) }
  end
end