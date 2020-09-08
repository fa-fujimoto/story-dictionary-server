require 'rails_helper'

RSpec.describe ProjectFollower, type: :model do
  describe 'db' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(index: false, null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:project_id).of_type(:integer).with_options(index: false, null: false, foreign_key: true) }
    it { is_expected.not_to have_db_column(:editable).of_type(:boolean) }
    it { is_expected.to have_db_column(:permission).of_type(:integer).with_options(index: true, default: :view) }
    it { is_expected.to have_db_column(:approval).of_type(:boolean).with_options(index: true, null: false) }

    it { is_expected.to have_db_index([:user_id, :project_id]).unique }
  end

  describe 'enum' do
    it do
      is_expected.to define_enum_for(:permission)
        .with_values(view: 0, edit: 1, admin: 2)
        .with_prefix(true)
    end

    it do
      is_expected.to define_enum_for(:approval)
        .with_values(approved: true, unapproved: false)
        .backed_by_column_of_type(:boolean)
    end
  end

  describe 'association' do
    it { is_expected.to belong_to(:project).inverse_of(:followed_users) }
    it { is_expected.to belong_to(:user).inverse_of(:follow_projects) }
  end

  describe 'validate' do
    subject { build(:project_follower) }

    context 'project_id' do
      it { is_expected.to validate_uniqueness_of(:project_id).scoped_to(:user_id) }
    end

    context 'user_id' do
      it { is_expected.not_to allow_value(subject.project.author.id).for(:user_id) }
    end

    context 'apploval' do
      it { is_expected.to allow_value(:approved).for(:approval) }
      it { is_expected.to allow_value(:unapproved).for(:approval) }
      it { is_expected.not_to allow_value(nil).for(:approval) }
    end
  end

  describe '#followed_permission' do
    subject { project_follower.followed_permission }

    let(:project_follower) {
      create(
        :project_follower,
        project: create(:project, is_published: :protect),
        approval: approval,
        permission: permission
      )
    }

    describe 'if user has edit permission' do
      let(:approval) { :approved }
      let(:permission) { :edit }

      it { is_expected.to eq 'edit' }
    end

    describe 'if user has view permission' do
      let(:approval) { :approved }
      let(:permission) { :view }

      it { is_expected.to eq 'view' }
    end

    describe 'if user has admin permission' do
      let(:approval) { :approved }
      let(:permission) { :admin }

      it { is_expected.to eq 'admin' }
    end

    describe 'if user is requesting' do
      let(:approval) { :unapproved }

      describe 'has view permission' do
        let(:permission) { :view }

        it { is_expected.to eq 'requesting' }
      end

      describe 'has edit permission' do
        let(:permission) { :edit }

        it { is_expected.to eq 'requesting' }
      end

      describe 'has admin permission' do
        let(:permission) { :admin }

        it { is_expected.to eq 'requesting' }
      end
    end
  end
end
