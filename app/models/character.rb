class Character < ApplicationRecord
  include Item

  has_many :assigned_groups, class_name: 'AssignedMember', inverse_of: 'member', dependent: :destroy
  has_many :groups, through: :assigned_groups

  has_many :relations_from, class_name: :CharacterRelation, foreign_key: :from_id, inverse_of: :from, dependent: :destroy
  has_many :relations_to, class_name: :CharacterRelation, foreign_key: :to_id, inverse_of: :to, dependent: :destroy
  has_many :relationing, through: :relations_from, source: :to
  has_many :relationed, through: :relations_to, source: :from
end
