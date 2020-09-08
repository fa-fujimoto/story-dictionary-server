require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  describe 'when create user' do
    let(:user) { create(:user) }

    describe "matches to serialized JSON" do
      subject { JSON.parse(serializer.to_json) }

      let(:current_user) { user }
      let(:serializer) { UserSerializer.new(user, scope: current_user, scope_name: :current_user) }

      it { expect(subject['name']).to eq user.name }
      it { expect(subject['nickname']).to eq user.nickname }
      it { expect(subject['image']).to eq user.image }
      it { expect(subject['email']).to be_nil }
      it { expect(subject['password']).to be_nil }
    end

    describe "matches to serialized JSON with projects" do
      subject { JSON.parse(serializer.to_json)['projects'].pluck('term_id') }
      let(:serializer) { UserSerializer.new(user, include: [:projects], scope: current_user, scope_name: :current_user) }
      let!(:published_project) { create(:project, author: user, is_published: :published) }
      let!(:protect_project) { create(:project, author: user, is_published: :protect) }

      describe 'not longin' do
        let(:current_user) { nil }

        it { is_expected.to include published_project.term_id }
        it { is_expected.not_to include protect_project.term_id }
      end

      describe 'longined author' do
        let(:current_user) { user }

        it { is_expected.to include published_project.term_id }
        it { is_expected.to include protect_project.term_id }
      end

      describe 'longined other user' do
        let(:current_user) { create(:user) }

        it { is_expected.to include published_project.term_id }
        it { is_expected.not_to include protect_project.term_id }
      end
    end

    describe "matches to serialized JSON with follow projects" do
      let(:serializer) { UserSerializer.new(user, include: [:following_projects, :requesting_projects], scope: current_user, scope_name: :current_user) }
      let!(:published_project) { create(:project, is_published: :published) }
      let!(:protect_project) { create(:project, is_published: :protect) }
      let!(:requesting_published_project) { create(:project, is_published: :published) }
      let!(:requesting_protect_project) { create(:project, is_published: :protect) }

      before do
        create(:project_follower, project: published_project, user: user, approval: :approved)
        create(:project_follower, project: protect_project, user: user, approval: :approved)
        create(:project_follower, project: requesting_protect_project, user: user, approval: :unapproved)
      end

      describe 'following projects' do
        subject { JSON.parse(serializer.to_json)['following_projects'].pluck('term_id') }

        describe 'not longin' do
          let(:current_user) { nil }

          it { is_expected.to include published_project.term_id }
          it { is_expected.not_to include protect_project.term_id }
          it { is_expected.not_to include requesting_protect_project.term_id }
        end

        describe 'longined author' do
          let(:current_user) { user }

          it { is_expected.to include published_project.term_id }
          it { is_expected.to include protect_project.term_id }
          it { is_expected.not_to include requesting_protect_project.term_id }
        end

        describe 'longined other user' do
          let(:current_user) { create(:user) }

          it { is_expected.to include published_project.term_id }
          it { is_expected.not_to include protect_project.term_id }
          it { is_expected.not_to include requesting_protect_project.term_id }
        end
      end

      describe 'requesting projects' do
        subject { JSON.parse(serializer.to_json)['requesting_projects'].pluck('term_id') }

        describe 'not longin' do
          let(:current_user) { nil }

          it { expect(JSON.parse(serializer.to_json)).not_to include 'requesting_projects' }
        end

        describe 'longined author' do
          let(:current_user) { user }

          it { is_expected.not_to include published_project.term_id }
          it { is_expected.not_to include protect_project.term_id }
          it { is_expected.to include requesting_protect_project.term_id }
        end

        describe 'longined other user' do
          let(:current_user) { create(:user) }

          it { expect(JSON.parse(serializer.to_json)).not_to include 'requesting_projects' }
        end
      end
    end
  end
end