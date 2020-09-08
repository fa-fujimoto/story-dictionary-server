module Item
  extend ActiveSupport::Concern

  included do
    belongs_to :post, touch: true

    validates :post_id, uniqueness: true

    def is_same_project_affiliation?(item)
      item && post.settable_post_for?(item.post)
    end
  end
end