require 'rails_helper'

RSpec.describe AssignedMember, type: :model do
  subject { build(:assigned_member) }

  describe 'association' do
    it { should belong_to(:member).class_name('Character').with_foreign_key('character_id').inverse_of('assigned_groups').touch(true) }
    it { should belong_to(:group).touch(true) }
  end

  describe 'validation' do
    it { should validate_uniqueness_of(:group_id).scoped_to(:character_id) }
    it do
      should validate_length_of(:description)
        .is_at_least(1)
        .is_at_most(30)
        .allow_blank
    end

    it do
      should validate_length_of(:detail)
        .is_at_least(1)
        .is_at_most(10000)
        .allow_blank
    end
  end
end
