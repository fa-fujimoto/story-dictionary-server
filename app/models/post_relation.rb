class PostRelation < ApplicationRecord
  include Relation

  belongs_to :from, class_name: :Post, foreign_key: :from_id, inverse_of: :relations_from
  belongs_to :to, class_name: :Post, foreign_key: :to_id, inverse_of: :relations_to

  validate do
    if from && to && !from.settable_post_for?(to)
      errors.add(:base, :invalid)
    end
  end
end
