require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'association' do
    it { is_expected.to belong_to(:post).touch(true) }
    it { is_expected.to belong_to(:parent).class_name('Group').with_foreign_key('parent_id').inverse_of(:children).optional }

    it { is_expected.to have_many(:children).class_name('Group').with_foreign_key('parent_id').inverse_of(:parent).dependent(:destroy) }
    it { is_expected.to have_many(:assigned_members).dependent(:destroy) }
    it { is_expected.to have_many(:members).through(:assigned_members) }

    it { is_expected.to have_many(:relations_from).class_name(GroupRelation).with_foreign_key(:from_id).inverse_of(:from).dependent(:destroy) }
    it { is_expected.to have_many(:relations_to).class_name(GroupRelation).with_foreign_key(:to_id).inverse_of(:to).dependent(:destroy) }
    it { is_expected.to have_many(:relationing).through(:relations_from).source(:to) }
    it { is_expected.to have_many(:relationed).through(:relations_to).source(:from) }
  end

  describe 'validation' do
    subject { build(:group) }
    it { is_expected.to validate_uniqueness_of(:post_id) }
    it { is_expected.to allow_value(true).for(:is_department) }
    it { is_expected.to allow_value(false).for(:is_department) }
    it { is_expected.not_to allow_value(nil).for(:is_department) }

    context 'if department' do
      before { allow(subject).to receive(:is_department).and_return(true) }
      it { is_expected.to validate_presence_of(:parent) }
    end

    context 'if organization' do
      before { allow(subject).to receive(:is_department).and_return(false) }
      it { is_expected.not_to validate_presence_of(:parent) }
    end
  end

  describe 'custom validation' do
    subject { group.invalid? }

    describe '#check_parent_belong_to_projec' do
      let(:group) { build(:group, project: project, parent: parent) }
      let(:project) { create(:project) }
      let(:parent) { create(:group, project: parent_belong_to_project) }

      context 'if same project' do
        let(:parent_belong_to_project) { project }

        it { is_expected.to be_falsey }
      end

      context 'if other project' do
        let(:parent_belong_to_project) { create(:project) }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#belong_to_organization' do
    subject { group.belong_to_organization }

    let(:project) { create(:project) }

    describe 'depth 2' do
      context 'lower department' do
        let(:organization) { create(:group, is_department: false, project: project) }
        let(:department) { create(:group, is_department: true, parent: organization, project: project) }
        let(:group) { create(:group, is_department: true, parent: department, project: project) }

        it { is_expected.to eq organization }
      end

      context 'lower organization' do
        let(:organization) { create(:group, is_department: false, project: project) }
        let(:department) { create(:group, is_department: false, parent: organization, project: project) }
        let(:group) { create(:group, is_department: true, parent: department, project: project) }

        it { is_expected.to eq department }
      end

      context 'self organization' do
        let(:organization) { create(:group, is_department: false, project: project) }
        let(:department) { create(:group, is_department: false, parent: organization, project: project) }
        let(:group) { create(:group, is_department: false, parent: department, project: project) }

        it { is_expected.to eq nil }
      end
    end

    describe 'depth 1' do
      context 'lower organization' do
        let(:organization) { create(:group, is_department: false, project: project) }
        let(:group) { create(:group, is_department: true, parent: organization, project: project) }

        it { is_expected.to eq organization }
      end

      context 'self organization' do
        let(:organization) { create(:group, is_department: false, project: project) }
        let(:group) { create(:group, is_department: false, parent: organization, project: project) }

        it { is_expected.to eq nil }
      end
    end

    describe 'depth 0' do
      context 'self organization' do
        let(:group) { create(:group, is_department: false, project: project) }

        it { is_expected.to eq nil }
      end
    end
  end

  describe '#all_members' do
    let(:project) { create(:project) }
    let(:organization) { create(:group, is_department: false, project: project) }
    let(:middle_department) { create(:group, is_department: true, parent: organization, project: project) }
    let(:lower_department) { create(:group, is_department: true, parent: middle_department, project: project) }

    let(:organization_member) { create(:character, project: project) }
    let(:middle_department_member) { create(:character, project: project) }
    let(:lower_department_member) { create(:character, project: project) }
    let(:duplicate_member) { create(:character, project: project) }

    before {
      create(:assigned_member, member: organization_member, group: organization)
      create(:assigned_member, member: middle_department_member, group: middle_department)
      create(:assigned_member, member: lower_department_member, group: lower_department)

      create(:assigned_member, member: duplicate_member, group: organization)
      create(:assigned_member, member: duplicate_member, group: middle_department)
      create(:assigned_member, member: duplicate_member, group: lower_department)
    }

    context 'organization' do
      subject { organization.all_members }

      it { is_expected.to include organization_member }
      it { is_expected.to include middle_department_member }
      it { is_expected.to include lower_department_member }

      it { is_expected.to eq subject.uniq }
    end

    context 'middle_department' do
      subject { middle_department.all_members }

      it { is_expected.not_to include organization_member }
      it { is_expected.to include middle_department_member }
      it { is_expected.to include lower_department_member }

      it { is_expected.to eq subject.uniq }
    end

    context 'lower_department' do
      subject { lower_department.all_members }

      it { is_expected.not_to include organization_member }
      it { is_expected.not_to include middle_department_member }
      it { is_expected.to include lower_department_member }

      it { is_expected.to eq subject.uniq }
    end
  end

  describe 'scope' do
    let(:project) { create(:project) }
    let(:organization) { create(:group, is_department: false, project: project) }
    let(:middle_department) { create(:group, is_department: true, parent: organization, project: project) }
    let(:lower_department) { create(:group, is_department: true, parent: middle_department, project: project) }

    let(:middle_organization) { create(:group, is_department: true, parent: organization, project: project) }
    let(:lower_organization) { create(:group, is_department: true, parent: middle_organization, project: project) }

    describe '#top_level_organization' do
      subject { Group.top_level_organization }

      it { is_expected.to include organization }
      it { is_expected.not_to include middle_department }
      it { is_expected.not_to include lower_department }
      it { is_expected.not_to include middle_organization }
      it { is_expected.not_to include lower_organization }
    end
  end
end
