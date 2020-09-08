require 'rails_helper'

params_length = Project::PARAMS_LENGTH

RSpec.describe Project, type: :model do
  describe 'db' do
    it { is_expected.to have_db_column(:commentable_status).of_type(:integer).with_options(default: :free) }
    it { is_expected.to have_db_column(:comment_viewable).of_type(:integer).with_options(default: :open) }
    it { is_expected.to have_db_column(:comment_publish).of_type(:integer).with_options(default: :soon) }

    it { is_expected.to have_db_index(:commentable_status) }
    it { is_expected.to have_db_index(:comment_viewable) }
    it { is_expected.to have_db_index(:comment_publish) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:author).class_name(:User).with_foreign_key(:user_id) }

    it { is_expected.to have_many(:categories).dependent(:destroy) }
    it { is_expected.to have_many(:custom_folders).dependent(:destroy) }
    it { is_expected.to have_many(:visible_custom_folders).class_name(:CustomFolder) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }

    it { is_expected.to have_many(:attribute_configs).dependent(:destroy) }
    it { is_expected.to have_many(:attribute_items).through(:attribute_configs).source(:item).dependent(:destroy) }

    it { is_expected.to have_many(:words).class_name(:Post) }
    it { is_expected.to have_many(:characters).class_name(:Post) }
    it { is_expected.to have_many(:groups).class_name(:Post) }

    it { is_expected.to have_many(:follower_viewable_words).class_name(:Post) }
    it { is_expected.to have_many(:follower_viewable_characters).class_name(:Post) }
    it { is_expected.to have_many(:follower_viewable_groups).class_name(:Post) }

    it { is_expected.to have_many(:published_words).class_name(:Post) }
    it { is_expected.to have_many(:published_characters).class_name(:Post) }
    it { is_expected.to have_many(:published_groups).class_name(:Post) }

    it { is_expected.to have_many(:follow_statuses).class_name(:ProjectFollower).dependent(:destroy) }

    it { is_expected.to have_many(:followed_users).conditions(approval: true).class_name(:ProjectFollower) }
    it { is_expected.to have_many(:followers).through(:followed_users).source(:user) }

    it { is_expected.to have_many(:follow_requests).conditions(approval: false).class_name(:ProjectFollower) }
    it { is_expected.to have_many(:requesting_users).through(:follow_requests).source(:user) }
  end

  describe 'post association' do
    let(:project) { create(:project) }

    let!(:published_word) { create(:post, :with_word, :published, project: project) }
    let!(:published_character) { create(:post, :with_character, :published, project: project) }
    let!(:published_group) { create(:post, :with_group, :published, project: project) }

    let!(:protect_word) { create(:post, :with_word, :protect, project: project) }
    let!(:protect_character) { create(:post, :with_character, :protect, project: project) }
    let!(:protect_group) { create(:post, :with_group, :protect, project: project) }

    let!(:draft_word) { create(:post, :with_word, :draft, project: project) }
    let!(:draft_character) { create(:post, :with_character, :draft, project: project) }
    let!(:draft_group) { create(:post, :with_group, :draft, project: project) }

    let!(:deleted_word) { create(:post, :with_word, :deleted, project: project) }
    let!(:deleted_character) { create(:post, :with_character, :deleted, project: project) }
    let!(:deleted_group) { create(:post, :with_group, :deleted, project: project) }

    describe 'words' do
      subject { project.words }

      it { is_expected.to include published_word }
      it { is_expected.not_to include published_character }
      it { is_expected.not_to include published_group }

      it { is_expected.to include protect_word }
      it { is_expected.not_to include protect_character }
      it { is_expected.not_to include protect_group }

      it { is_expected.to include draft_word }
      it { is_expected.not_to include draft_character }
      it { is_expected.not_to include draft_group }

      it { is_expected.to include deleted_word }
      it { is_expected.not_to include deleted_character }
      it { is_expected.not_to include deleted_group }
    end

    describe 'characters' do
      subject { project.characters }

      it { is_expected.not_to include published_word }
      it { is_expected.to include published_character }
      it { is_expected.not_to include published_group }

      it { is_expected.not_to include protect_word }
      it { is_expected.to include protect_character }
      it { is_expected.not_to include protect_group }

      it { is_expected.not_to include draft_word }
      it { is_expected.to include draft_character }
      it { is_expected.not_to include draft_group }

      it { is_expected.not_to include deleted_word }
      it { is_expected.to include deleted_character }
      it { is_expected.not_to include deleted_group }
    end

    describe 'groups' do
      subject { project.groups }

      it { is_expected.not_to include published_word }
      it { is_expected.not_to include published_character }
      it { is_expected.to include published_group }

      it { is_expected.not_to include protect_word }
      it { is_expected.not_to include protect_character }
      it { is_expected.to include protect_group }

      it { is_expected.not_to include draft_word }
      it { is_expected.not_to include draft_character }
      it { is_expected.to include draft_group }

      it { is_expected.not_to include deleted_word }
      it { is_expected.not_to include deleted_character }
      it { is_expected.to include deleted_group }
    end

    describe 'follower_viewable_words' do
      subject { project.follower_viewable_words }

      it { is_expected.to include published_word }
      it { is_expected.not_to include published_character }
      it { is_expected.not_to include published_group }

      it { is_expected.to include protect_word }
      it { is_expected.not_to include protect_character }
      it { is_expected.not_to include protect_group }

      it { is_expected.not_to include draft_word }
      it { is_expected.not_to include draft_character }
      it { is_expected.not_to include draft_group }

      it { is_expected.not_to include deleted_word }
      it { is_expected.not_to include deleted_character }
      it { is_expected.not_to include deleted_group }
    end

    describe 'follower_viewable_characters' do
      subject { project.follower_viewable_characters }

      it { is_expected.not_to include published_word }
      it { is_expected.to include published_character }
      it { is_expected.not_to include published_group }

      it { is_expected.not_to include protect_word }
      it { is_expected.to include protect_character }
      it { is_expected.not_to include protect_group }

      it { is_expected.not_to include draft_word }
      it { is_expected.not_to include draft_character }
      it { is_expected.not_to include draft_group }

      it { is_expected.not_to include deleted_word }
      it { is_expected.not_to include deleted_character }
      it { is_expected.not_to include deleted_group }
    end

    describe 'follower_viewable_groups' do
      subject { project.follower_viewable_groups }

      it { is_expected.not_to include published_word }
      it { is_expected.not_to include published_character }
      it { is_expected.to include published_group }

      it { is_expected.not_to include protect_word }
      it { is_expected.not_to include protect_character }
      it { is_expected.to include protect_group }

      it { is_expected.not_to include draft_word }
      it { is_expected.not_to include draft_character }
      it { is_expected.not_to include draft_group }

      it { is_expected.not_to include deleted_word }
      it { is_expected.not_to include deleted_character }
      it { is_expected.not_to include deleted_group }
    end

    describe 'published_words' do
      subject { project.published_words }

      it { is_expected.to include published_word }
      it { is_expected.not_to include published_character }
      it { is_expected.not_to include published_group }

      it { is_expected.not_to include protect_word }
      it { is_expected.not_to include protect_character }
      it { is_expected.not_to include protect_group }

      it { is_expected.not_to include draft_word }
      it { is_expected.not_to include draft_character }
      it { is_expected.not_to include draft_group }

      it { is_expected.not_to include deleted_word }
      it { is_expected.not_to include deleted_character }
      it { is_expected.not_to include deleted_group }
    end

    describe 'published_characters' do
      subject { project.published_characters }

      it { is_expected.not_to include published_word }
      it { is_expected.to include published_character }
      it { is_expected.not_to include published_group }

      it { is_expected.not_to include protect_word }
      it { is_expected.not_to include protect_character }
      it { is_expected.not_to include protect_group }

      it { is_expected.not_to include draft_word }
      it { is_expected.not_to include draft_character }
      it { is_expected.not_to include draft_group }

      it { is_expected.not_to include deleted_word }
      it { is_expected.not_to include deleted_character }
      it { is_expected.not_to include deleted_group }
    end

    describe 'published_groups' do
      subject { project.published_groups }

      it { is_expected.not_to include published_word }
      it { is_expected.not_to include published_character }
      it { is_expected.to include published_group }

      it { is_expected.not_to include protect_word }
      it { is_expected.not_to include protect_character }
      it { is_expected.not_to include protect_group }

      it { is_expected.not_to include draft_word }
      it { is_expected.not_to include draft_character }
      it { is_expected.not_to include draft_group }

      it { is_expected.not_to include deleted_word }
      it { is_expected.not_to include deleted_character }
      it { is_expected.not_to include deleted_group }
    end
  end

  describe 'enum' do
    it do
      is_expected.to define_enum_for(:commentable_status)
        .with_values(free: 0, followers_only: 1, editors_only: 2)
        .with_prefix(true)
    end

    it do
      is_expected.to define_enum_for(:comment_viewable)
        .with_values(open: 0, followers_only: 1, editors_only: 2, hidden: -1)
        .with_prefix(true)
    end

    it do
      is_expected.to define_enum_for(:comment_publish)
        .with_values(soon: 0, after_approval: 1, after_approval_only_for_guest: 2)
        .with_prefix(true)
    end

    it do
      is_expected.to define_enum_for(:is_published)
        .with_values(published: true, protect: false)
        .backed_by_column_of_type(:boolean)
    end
  end

  describe 'permission check' do
    let(:author) { create(:user) }
    let(:viewer) { create(:user) }
    let(:editor) { create(:user) }
    let(:administrator) { create(:user) }
    let(:approval_pending_user) { create(:user) }
    let(:other) { create(:user) }

    let(:commentable_status) { :free }
    let(:comment_viewable) { :open }
    let(:comment_publish) { :soon }

    let(:project) {
      create(
        :project,
        is_published: is_published,
        author: author,
        commentable_status: commentable_status,
        comment_viewable: comment_viewable,
        comment_publish: comment_publish
      )
    }

    before {
      create(:project_follower, project: project, user: viewer, permission: :view, approval: :approved)
      create(:project_follower, project: project, user: editor, permission: :edit, approval: :approved)
      create(:project_follower, project: project, user: administrator, permission: :admin, approval: :approved)
      create(:project_follower, project: project, user: approval_pending_user, permission: :edit, approval: :unapproved)
    }

    describe '#viewable?' do
      subject { project.viewable?(user) }

      describe 'protect' do
        let(:is_published) { :protect }

        context 'author' do
          let(:user) { author }
          it { is_expected.to be_truthy }
        end

        context 'viewer' do
          let(:user) { viewer }
          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }
          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }
          it { is_expected.to be_truthy }
        end

        context 'approval_pending_user' do
          let(:user) { approval_pending_user }
          it { is_expected.to be_falsey }
        end

        context 'other' do
          let(:user) { other }
          it { is_expected.to be_falsey }
        end
      end

      describe 'public' do
        let(:is_published) { :published }

        context 'author' do
          let(:user) { author }
          it { is_expected.to be_truthy }
        end

        context 'viewer' do
          let(:user) { viewer }
          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }
          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }
          it { is_expected.to be_truthy }
        end

        context 'other' do
          let(:user) { other }
          it { is_expected.to be_truthy }
        end
      end
    end

    describe '#editable?' do
      subject { project.editable?(user) }

      describe 'protect' do
        let(:is_published) { :protect }

        context 'author' do
          let(:user) { author }
          it { is_expected.to be_truthy }
        end

        context 'viewer' do
          let(:user) { viewer }
          it { is_expected.to be_falsey }
        end

        context 'editor' do
          let(:user) { editor }
          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }
          it { is_expected.to be_truthy }
        end

        context 'approval_pending_user' do
          let(:user) { approval_pending_user }
          it { is_expected.to be_falsey }
        end

        context 'other' do
          let(:user) { other }
          it { is_expected.to be_falsey }
        end
      end

      describe 'public' do
        let(:is_published) { :published }

        context 'author' do
          let(:user) { author }
          it { is_expected.to be_truthy }
        end

        context 'viewer' do
          let(:user) { viewer }
          it { is_expected.to be_falsey }
        end

        context 'editor' do
          let(:user) { editor }
          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }
          it { is_expected.to be_truthy }
        end

        context 'other' do
          let(:user) { other }
          it { is_expected.to be_falsey }
        end
      end
    end

    describe '#followed?' do
      subject { project.followed?(user) }

      describe 'protect' do
        let(:is_published) { :protect }

        context 'author' do
          let(:user) { author }
          it { is_expected.to be_falsey }
        end

        context 'viewer' do
          let(:user) { viewer }
          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }
          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }
          it { is_expected.to be_truthy }
        end

        context 'approval_pending_user' do
          let(:user) { approval_pending_user }
          it { is_expected.to be_falsey }
        end

        context 'other' do
          let(:user) { other }
          it { is_expected.to be_falsey }
        end
      end

      describe 'public' do
        let(:is_published) { :published }

        context 'author' do
          let(:user) { author }
          it { is_expected.to be_falsey }
        end

        context 'viewer' do
          let(:user) { viewer }
          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }
          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }
          it { is_expected.to be_truthy }
        end

        context 'other' do
          let(:user) { other }
          it { is_expected.to be_falsey }
        end
      end
    end

    describe '#followable?' do
      subject { project.followable?(user) }

      describe 'protect' do
        let(:is_published) { :protect }

        context 'author' do
          let(:user) { author }
          it { is_expected.to be_falsey }
        end

        context 'viewer' do
          let(:user) { viewer }
          it { is_expected.to be_falsey }
        end

        context 'editor' do
          let(:user) { editor }
          it { is_expected.to be_falsey }
        end

        context 'administrator' do
          let(:user) { administrator }
          it { is_expected.to be_falsey }
        end

        context 'approval_pending_user' do
          let(:user) { approval_pending_user }
          it { is_expected.to be_falsey }
        end

        context 'other' do
          let(:user) { other }
          it { is_expected.to be_truthy }
        end
      end

      describe 'public' do
        let(:is_published) { :published }

        context 'author' do
          let(:user) { author }
          it { is_expected.to be_falsey }
        end

        context 'viewer' do
          let(:user) { viewer }
          it { is_expected.to be_falsey }
        end

        context 'editor' do
          let(:user) { editor }
          it { is_expected.to be_falsey }
        end

        context 'administrator' do
          let(:user) { administrator }
          it { is_expected.to be_falsey }
        end

        context 'other' do
          let(:user) { other }
          it { is_expected.to be_truthy }
        end
      end
    end

    describe '#commentable_for?' do
      subject { project.commentable_for?(user) }

      describe 'protect' do
        let(:is_published) { :protect }

        describe 'commentable status free' do
          let(:commentable_status) { :free }

          describe 'comment viewable open' do
            let(:comment_viewable) { :open }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_truthy }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable followers only' do
            let(:comment_viewable) { :followers_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_truthy }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable editors only' do
            let(:comment_viewable) { :editors_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable hidden' do
            let(:comment_viewable) { :hidden }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_falsey }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_falsey }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_falsey }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end
        end

        describe 'commentable status followers only' do
          let(:commentable_status) { :followers_only }

          describe 'comment viewable open' do
            let(:comment_viewable) { :open }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_truthy }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable followers only' do
            let(:comment_viewable) { :followers_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_truthy }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable editors only' do
            let(:comment_viewable) { :editors_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable hidden' do
            let(:comment_viewable) { :hidden }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_falsey }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_falsey }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_falsey }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end
        end

        describe 'commentable status editors only' do
          let(:commentable_status) { :editors_only }

          describe 'comment viewable open' do
            let(:comment_viewable) { :open }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable followers only' do
            let(:comment_viewable) { :followers_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable editors only' do
            let(:comment_viewable) { :editors_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable hidden' do
            let(:comment_viewable) { :hidden }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_falsey }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_falsey }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_falsey }
            end

            context 'approval_pending_user' do
              let(:user) { approval_pending_user }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end
        end
      end

      describe 'published' do
        let(:is_published) { :published }

        describe 'commentable status free' do
          let(:commentable_status) { :free }

          describe 'comment viewable open' do
            let(:comment_viewable) { :open }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_truthy }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_truthy }
            end
          end

          describe 'comment viewable followers only' do
            let(:comment_viewable) { :followers_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_truthy }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable editors only' do
            let(:comment_viewable) { :editors_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable hidden' do
            let(:comment_viewable) { :hidden }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_falsey }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_falsey }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end
        end

        describe 'commentable status followers only' do
          let(:commentable_status) { :followers_only }

          describe 'comment viewable open' do
            let(:comment_viewable) { :open }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_truthy }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable followers only' do
            let(:comment_viewable) { :followers_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_truthy }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable editors only' do
            let(:comment_viewable) { :editors_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable hidden' do
            let(:comment_viewable) { :hidden }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_falsey }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_falsey }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end
        end

        describe 'commentable status editors only' do
          let(:commentable_status) { :editors_only }

          describe 'comment viewable open' do
            let(:comment_viewable) { :open }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable followers only' do
            let(:comment_viewable) { :followers_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable editors only' do
            let(:comment_viewable) { :editors_only }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_truthy }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_truthy }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_truthy }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end

          describe 'comment viewable hidden' do
            let(:comment_viewable) { :hidden }

            context 'author' do
              let(:user) { author }
              it { is_expected.to be_falsey }
            end

            context 'viewer' do
              let(:user) { viewer }
              it { is_expected.to be_falsey }
            end

            context 'editor' do
              let(:user) { editor }
              it { is_expected.to be_falsey }
            end

            context 'administrator' do
              let(:user) { administrator }
              it { is_expected.to be_falsey }
            end

            context 'other' do
              let(:user) { other }
              it { is_expected.to be_falsey }
            end
          end
        end
      end
    end

    describe '#comment_viewable_for?' do
      subject { project.comment_viewable_for?(user) }
      describe 'protect' do
        let(:is_published) { :protect }

        describe 'comment viewable open' do
          let(:comment_viewable) { :open }

          context 'author' do
            let(:user) { author }
            it { is_expected.to be_truthy }
          end

          context 'viewer' do
            let(:user) { viewer }
            it { is_expected.to be_truthy }
          end

          context 'editor' do
            let(:user) { editor }
            it { is_expected.to be_truthy }
          end

          context 'administrator' do
            let(:user) { administrator }
            it { is_expected.to be_truthy }
          end

          context 'approval_pending_user' do
            let(:user) { approval_pending_user }
            it { is_expected.to be_falsey }
          end

          context 'other' do
            let(:user) { other }
            it { is_expected.to be_falsey }
          end
        end

        describe 'comment viewable followers only' do
          let(:comment_viewable) { :followers_only }

          context 'author' do
            let(:user) { author }
            it { is_expected.to be_truthy }
          end

          context 'viewer' do
            let(:user) { viewer }
            it { is_expected.to be_truthy }
          end

          context 'editor' do
            let(:user) { editor }
            it { is_expected.to be_truthy }
          end

          context 'administrator' do
            let(:user) { administrator }
            it { is_expected.to be_truthy }
          end

          context 'approval_pending_user' do
            let(:user) { approval_pending_user }
            it { is_expected.to be_falsey }
          end

          context 'other' do
            let(:user) { other }
            it { is_expected.to be_falsey }
          end
        end

        describe 'comment viewable editors only' do
          let(:comment_viewable) { :editors_only }

          context 'author' do
            let(:user) { author }
            it { is_expected.to be_truthy }
          end

          context 'viewer' do
            let(:user) { viewer }
            it { is_expected.to be_falsey }
          end

          context 'editor' do
            let(:user) { editor }
            it { is_expected.to be_truthy }
          end

          context 'administrator' do
            let(:user) { administrator }
            it { is_expected.to be_truthy }
          end

          context 'approval_pending_user' do
            let(:user) { approval_pending_user }
            it { is_expected.to be_falsey }
          end

          context 'other' do
            let(:user) { other }
            it { is_expected.to be_falsey }
          end
        end

        describe 'comment viewable hidden' do
          let(:comment_viewable) { :hidden }

          context 'author' do
            let(:user) { author }
            it { is_expected.to be_falsey }
          end

          context 'viewer' do
            let(:user) { viewer }
            it { is_expected.to be_falsey }
          end

          context 'editor' do
            let(:user) { editor }
            it { is_expected.to be_falsey }
          end

          context 'administrator' do
            let(:user) { administrator }
            it { is_expected.to be_falsey }
          end

          context 'approval_pending_user' do
            let(:user) { approval_pending_user }
            it { is_expected.to be_falsey }
          end

          context 'other' do
            let(:user) { other }
            it { is_expected.to be_falsey }
          end
        end
      end

      describe 'published' do
        let(:is_published) { :published }

        describe 'comment viewable open' do
          let(:comment_viewable) { :open }

          context 'author' do
            let(:user) { author }
            it { is_expected.to be_truthy }
          end

          context 'viewer' do
            let(:user) { viewer }
            it { is_expected.to be_truthy }
          end

          context 'editor' do
            let(:user) { editor }
            it { is_expected.to be_truthy }
          end

          context 'administrator' do
            let(:user) { administrator }
            it { is_expected.to be_truthy }
          end

          context 'other' do
            let(:user) { other }
            it { is_expected.to be_truthy }
          end
        end

        describe 'comment viewable followers only' do
          let(:comment_viewable) { :followers_only }

          context 'author' do
            let(:user) { author }
            it { is_expected.to be_truthy }
          end

          context 'viewer' do
            let(:user) { viewer }
            it { is_expected.to be_truthy }
          end

          context 'editor' do
            let(:user) { editor }
            it { is_expected.to be_truthy }
          end

          context 'administrator' do
            let(:user) { administrator }
            it { is_expected.to be_truthy }
          end

          context 'other' do
            let(:user) { other }
            it { is_expected.to be_falsey }
          end
        end

        describe 'comment viewable editors only' do
          let(:comment_viewable) { :editors_only }

          context 'author' do
            let(:user) { author }
            it { is_expected.to be_truthy }
          end

          context 'viewer' do
            let(:user) { viewer }
            it { is_expected.to be_falsey }
          end

          context 'editor' do
            let(:user) { editor }
            it { is_expected.to be_truthy }
          end

          context 'administrator' do
            let(:user) { administrator }
            it { is_expected.to be_truthy }
          end

          context 'other' do
            let(:user) { other }
            it { is_expected.to be_falsey }
          end
        end

        describe 'comment viewable hidden' do
          let(:comment_viewable) { :hidden }

          context 'author' do
            let(:user) { author }
            it { is_expected.to be_falsey }
          end

          context 'viewer' do
            let(:user) { viewer }
            it { is_expected.to be_falsey }
          end

          context 'editor' do
            let(:user) { editor }
            it { is_expected.to be_falsey }
          end

          context 'administrator' do
            let(:user) { administrator }
            it { is_expected.to be_falsey }
          end

          context 'other' do
            let(:user) { other }
            it { is_expected.to be_falsey }
          end
        end
      end
    end
  end

  describe '#followed_permission_for' do
    subject { project.followed_permission_for(user) }

    let(:user) { create(:user) }
    let(:project) { create(:project, is_published: :protect) }

    describe 'if user has edit permission' do
      before do
        create(:project_follower, user: user, project: project, approval: :approved, permission: :edit)
      end

      it { is_expected.to eq 'edit' }
    end

    describe 'if user has view permission' do
      before do
        create(:project_follower, user: user, project: project, approval: :approved, permission: :view)
      end

      it { is_expected.to eq 'view' }
    end

    describe 'if user has admin permission' do
      before do
        create(:project_follower, user: user, project: project, approval: :approved, permission: :admin)
      end

      it { is_expected.to eq 'admin' }
    end

    describe 'if user is requesting' do
      before do
        create(:project_follower, user: user, project: project, approval: :unapproved, permission: :view)
      end

      it { is_expected.to eq 'requesting' }
    end

    describe 'if user is not following' do
      before do
        allow(project).to receive(:author).and_return(user)
      end

      it { is_expected.to eq 'admin' }
    end

    describe 'if user is not following' do
      it { is_expected.to eq 'guest' }
    end
  end

  describe '#request_approve_to' do
    subject { project_follower.reload.approval }

    let!(:project_follower) { create(:project_follower, project: project, user: user, approval: :unapproved) }
    let(:project) { create(:project, is_published: :protect) }
    let(:user) { create(:user) }

    before do
      project.request_approve_to(user)
    end

    it { is_expected.to be_truthy }
  end

  describe '#comment_release_soon?' do
    subject { project.comment_release_soon?(user) }
    let(:project) { create(:project, author: author, comment_publish: comment_publish, is_published: is_published) }

    let(:author) { create(:user) }
    let(:administrator) { create(:user) }
    let(:editor) { create(:user) }
    let(:viewer) { create(:user) }
    let(:requesting_user) { create(:user) }
    let(:guest) { create(:user) }

    before do
      create(:project_follower, project: project, user: administrator, permission: :admin)
      create(:project_follower, project: project, user: editor, permission: :edit)
      create(:project_follower, project: project, user: viewer, permission: :view)
      create(:project_follower, project: project, user: requesting_user, permission: :view, approval: :unapproved)
    end

    describe 'comment_publish_soon' do
      let(:comment_publish) { :soon }

      describe 'published' do
        let(:is_published) { :published }

        context 'author' do
          let(:user) { author }

          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }

          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }

          it { is_expected.to be_truthy }
        end

        context 'viewer' do
          let(:user) { viewer }

          it { is_expected.to be_truthy }
        end

        context 'requesting_user' do
          let(:user) { requesting_user }

          it { is_expected.to be_truthy }
        end

        context 'guest' do
          let(:user) { requesting_user }

          it { is_expected.to be_truthy }
        end
      end

      describe 'protect' do
        let(:is_published) { :protect }

        context 'author' do
          let(:user) { author }

          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }

          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }

          it { is_expected.to be_truthy }
        end

        context 'viewer' do
          let(:user) { viewer }

          it { is_expected.to be_truthy }
        end

        context 'requesting_user' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end

        context 'guest' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end
      end
    end

    describe 'comment_publish_after_approval' do
      let(:comment_publish) { :after_approval }

      describe 'published' do
        let(:is_published) { :published }

        context 'author' do
          let(:user) { author }

          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }

          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }

          it { is_expected.to be_falsey }
        end

        context 'viewer' do
          let(:user) { viewer }

          it { is_expected.to be_falsey }
        end

        context 'requesting_user' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end

        context 'guest' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end
      end

      describe 'protect' do
        let(:is_published) { :protect }

        context 'author' do
          let(:user) { author }

          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }

          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }

          it { is_expected.to be_falsey }
        end

        context 'viewer' do
          let(:user) { viewer }

          it { is_expected.to be_falsey }
        end

        context 'requesting_user' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end

        context 'guest' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end
      end
    end

    describe 'comment_publish_after_approval_only_for_guest' do
      let(:comment_publish) { :after_approval_only_for_guest }

      describe 'published' do
        let(:is_published) { :published }

        context 'author' do
          let(:user) { author }

          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }

          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }

          it { is_expected.to be_truthy }
        end

        context 'viewer' do
          let(:user) { viewer }

          it { is_expected.to be_falsey }
        end

        context 'requesting_user' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end

        context 'guest' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end
      end

      describe 'protect' do
        let(:is_published) { :protect }

        context 'author' do
          let(:user) { author }

          it { is_expected.to be_truthy }
        end

        context 'administrator' do
          let(:user) { administrator }

          it { is_expected.to be_truthy }
        end

        context 'editor' do
          let(:user) { editor }

          it { is_expected.to be_truthy }
        end

        context 'viewer' do
          let(:user) { viewer }

          it { is_expected.to be_falsey }
        end

        context 'requesting_user' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end

        context 'guest' do
          let(:user) { requesting_user }

          it { is_expected.to be_falsey }
        end
      end
    end
  end

  describe 'then project publishing' do
    subject { project.followed_users }

    let(:project) { create(:project, is_published: :protect) }

    before do
      create_list(:project_follower, 10, project: project, approval: :unapproved)

      project.update(is_published: :published)
    end

    it { is_expected.to all be_approved }
  end

  describe 'valid' do
    example '正常パターン' do
      expect(build(:project)).to be_valid
    end

    example 'MAXパターン' do
      expect(build(:project_max)).to be_valid
    end

    example 'MINパターン' do
      expect(build(:project_min)).to be_valid
    end
  end

  describe 'term_id' do
    let(:project) { build(:project, term_id: term_id) }

    context '値が存在しない場合' do
      let(:term_id) { nil }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context '全角文字が含まれる場合' do
      let(:term_id) { 'プロジェクトID' }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context '区切り記号が含まれる場合' do
      let(:term_id) { 'project_name_test' }

      example '不正にならないこと' do
        expect(project).not_to be_invalid
      end
    end

    context '許容外の記号が含まれる場合' do
      let(:term_id) { 'project@name*test' }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context '値が重複した場合' do
      let(:term_id) { 'project_name' }

      example '不正になること' do
        create(:project, term_id: term_id, author: project.author)

        expect(project).to be_invalid
      end
    end

    context "#{params_length.term_id.max + 1}文字以上の場合" do
      let(:term_id) { 'a' * (params_length.term_id.max + 1) }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context "#{params_length.term_id.min - 1}文字未満の場合" do
      let(:term_id) { 'a' * (params_length.term_id.min - 1) }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end
  end

  describe 'name' do
    let(:project) { build(:project, name: name) }

    context '値が存在しない場合' do
      let(:name) { nil }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context '記号が入った場合' do
      let(:name) { '~`!@#$%^&*()_+{}:"[];,./<>?\|' }

      example '不正にならないこと' do
        expect(project).not_to be_invalid
      end
    end

    context "#{params_length.name.max + 1}文字以上の場合" do
      let(:name) { 'a' * (params_length.name.max + 1) }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context "#{params_length.name.min - 1}文字未満の場合" do
      let(:name) { 'a' * (params_length.name.min - 1) }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end
  end

  describe 'kana' do
    let(:project) { build(:project, kana: kana) }

    context '値が存在しない場合' do
      let(:kana) { nil }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context 'カタカナが含まれる場合' do
      let(:kana) { 'プロジェクトネーム' }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context '漢字が含まれる場合' do
      let(:kana) { '企画名称' }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context '記号が含まれる場合' do
      let(:kana) { 'ぷろじぇくとねーむ@' }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context '頭文字がひらがな英数字以外の場合' do
      let(:kana) { ' ぷろじぇくとねーむ' }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context "#{params_length.kana.min - 1}文字未満の場合" do
      let(:kana) { 'a' * (params_length.kana.min - 1) }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end

    context "#{params_length.kana.max + 1}文字以上の場合" do
      let(:kana) { 'a' * (params_length.kana.max + 1) }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end
  end

  describe 'description' do
    let(:project) { build(:project, description: description) }

    context "#{params_length.description.max + 1}文字以上の場合" do
      let(:description) { 'a' * (params_length.description.max + 1) }

      example '不正になること' do
        expect(project).to be_invalid
      end
    end
  end
end
