require 'rails_helper'

RSpec.describe GroupRelation, type: :model do
  describe 'db' do
    subject { build(:group_relation) }

    it { is_expected.to have_db_column(:from_id).of_type(:integer).with_options(index: false, null: false, foreign_key: { to_table: :groups }) }
    it { is_expected.to have_db_column(:to_id).of_type(:integer).with_options(index: false, null: false, foreign_key: { to_table: :groups }) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:detail).of_type(:text) }

    it { is_expected.to have_db_index([:from_id, :to_id]).unique }
  end

  describe 'association' do
    subject { build(:group_relation) }

    it { is_expected.to belong_to(:from).class_name(:Group).with_foreign_key(:from_id).inverse_of(:relations_from).required }
    it { is_expected.to belong_to(:to).class_name(:Group).with_foreign_key(:to_id).inverse_of(:relations_to).required }
  end

  describe 'validation' do
    subject { build(:group_relation) }

    it { is_expected.to validate_uniqueness_of(:from_id).scoped_to(:to_id) }
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

  describe 'custom_validation' do
    describe 'equal project' do
      subject { group_relation.invalid? }

      let(:group1) { create(:group, project: project1) }
      let(:group2) { create(:group, project: project2) }
      let(:project1) { create(:project) }
      let(:group_relation) { build(:group_relation, from: group1, to: group2) }

      context 'if same project' do
        let(:project2) { project1 }

        it { is_expected.to be_falsey }
      end

      context 'if other project' do
        let(:project2) { create(:project) }

        it { is_expected.to be_truthy }
      end
    end

    describe 'relation set uniqueness' do
      subject { group_relation.invalid? }

      let(:group1) { create(:group, project: project) }
      let(:group2) { create(:group, project: project) }
      let(:project) { create(:project) }
      let(:group_relation) { build(:group_relation, from: group1, to: group2) }

      before { create(:group_relation, from: group2, to: group1) }

      it { is_expected.to be_falsey }
    end
  end
end
