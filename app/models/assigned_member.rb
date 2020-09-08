class AssignedMember < ApplicationRecord
  belongs_to :group, touch: true
  belongs_to :member, class_name: 'Character', foreign_key: 'character_id', inverse_of: 'assigned_groups', touch: true

  validates :description, length: { in: 1..30 }, allow_blank: true
  validates :detail, length: { in: 1..10000 }, allow_blank: true
  validates :group_id, uniqueness: { scope: :character_id }
  validate do
    if group && member && !group.is_same_project_affiliation?(member)
      errors.add(:base, :invalid)
    end
  end
end

