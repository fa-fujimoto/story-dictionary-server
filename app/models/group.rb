class Group < ApplicationRecord
  include Item

  belongs_to :parent, class_name: 'Group', foreign_key: 'parent_id', inverse_of: :children, optional: true

  has_many :children, class_name: 'Group', foreign_key: 'parent_id', inverse_of: :parent, dependent: :destroy

  has_many :assigned_members, dependent: :destroy
  has_many :members, through: :assigned_members

  has_many :relations_from, class_name: :GroupRelation, foreign_key: :from_id, inverse_of: :from, dependent: :destroy
  has_many :relations_to, class_name: :GroupRelation, foreign_key: :to_id, inverse_of: :to, dependent: :destroy
  has_many :relationing, through: :relations_from, source: :to
  has_many :relationed, through: :relations_to, source: :from

  validates :is_department, inclusion: { in: [true, false] }
  validates :parent, presence: { if: :is_department }
  validate do
    if parent && !is_same_project_affiliation?(parent)
      errors.add(:parent, :invalid)
    end
  end

  scope :top_level_organization, -> { where(is_department: false, parent_id: nil) }

  def belong_to_organization
    if (is_department)
      parent.is_department ? parent.belong_to_organization : parent
    end
  end

  def all_members(ary = [])
    ary.concat members

    children.find_each do |child|
      ary.concat child.all_members
    end

    ary.uniq
  end
end
