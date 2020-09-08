require 'rails_helper'

RSpec.describe Character, type: :model do
  describe 'association' do
    it { should belong_to(:post).touch(true) }
    it { should have_many(:assigned_groups).class_name('AssignedMember').inverse_of('member').dependent(:destroy) }
    it { should have_many(:groups).through(:assigned_groups) }

    it { is_expected.to have_many(:relations_from).class_name(CharacterRelation).with_foreign_key(:from_id).inverse_of(:from).dependent(:destroy) }
    it { is_expected.to have_many(:relations_to).class_name(CharacterRelation).with_foreign_key(:to_id).inverse_of(:to).dependent(:destroy) }
    it { is_expected.to have_many(:relationing).through(:relations_from).source(:to) }
    it { is_expected.to have_many(:relationed).through(:relations_to).source(:from) }
  end
end

