class CharacterRelation < ApplicationRecord
  include Relation

  belongs_to :from, class_name: :Character, foreign_key: :from_id, inverse_of: :relations_from
  belongs_to :to, class_name: :Character, foreign_key: :to_id, inverse_of: :relations_to

  validates :name, length: { in: 1..30 }, allow_blank: true

  validate do
    if from && to && !from.is_same_project_affiliation?(to)
      errors.add(:base, :invalid)
    end
  end
end
