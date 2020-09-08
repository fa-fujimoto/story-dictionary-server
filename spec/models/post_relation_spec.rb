require 'rails_helper'

RSpec.describe PostRelation, type: :model do
  describe 'db' do
    subject { build(:post_relation) }

    it { is_expected.to have_db_column(:from_id).of_type(:integer).with_options(index: false, null: false, foreign_key: { to_table: :groups }) }
    it { is_expected.to have_db_column(:to_id).of_type(:integer).with_options(index: false, null: false, foreign_key: { to_table: :groups }) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:detail).of_type(:text) }

    it { is_expected.to have_db_index([:from_id, :to_id]).unique }
  end

  describe 'association' do
    subject { build(:post_relation) }

    it { is_expected.to belong_to(:from).class_name(Post).with_foreign_key(:from_id).inverse_of(:relations_from).required }
    it { is_expected.to belong_to(:to).class_name(Post).with_foreign_key(:to_id).inverse_of(:relations_to).required }
  end

  describe 'validation' do
    subject { build(:post_relation) }

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
      subject { post_relation.invalid? }

      let(:post1) { create(:post, project: project1) }
      let(:post2) { create(:post, project: project2) }
      let(:project1) { create(:project) }
      let(:post_relation) { build(:post_relation, from: post1, to: post2) }

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
      subject { post_relation.invalid? }

      let(:post1) { create(:post, project: project) }
      let(:post2) { create(:post, project: project) }
      let(:project) { create(:project) }
      let(:post_relation) { build(:post_relation, from: post1, to: post2) }

      before { create(:post_relation, from: post2, to: post1) }

      it { is_expected.to be_falsey }
    end
  end
end
