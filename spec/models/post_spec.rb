require 'rails_helper'

length = Post::PARAMS_LENGTH

RSpec.describe Post, type: :model do
  describe 'db' do
    it { is_expected.to have_db_column(:status).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:disclosure_range).of_type(:integer) }
    it { is_expected.to have_db_index(:status) }
    it { is_expected.to have_db_index(:disclosure_range) }
  end

  describe 'association' do
    subject { build(:post) }

    it { is_expected.to accept_nested_attributes_for(:word).limit(1).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:character).limit(1).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:group).limit(1).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:custom).limit(1).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:attribute_values).allow_destroy(true) }

    it { is_expected.to have_one(:word).dependent(:destroy) }
    it { is_expected.to have_one(:character).dependent(:destroy) }
    it { is_expected.to have_one(:group).dependent(:destroy) }
    it { is_expected.to have_one(:custom).class_name('CustomPost').dependent(:destroy) }

    it { is_expected.to have_many(:attribute_values).dependent(:destroy) }
    it { is_expected.to have_many(:attribute_items).through(:attribute_values).source(:item) }

    it { is_expected.to have_many(:visible_attribute_values).class_name(:AttributeValue) }

    it { is_expected.to have_many(:relations_from).class_name(:PostRelation).with_foreign_key(:from_id).inverse_of(:from).dependent(:destroy) }
    it { is_expected.to have_many(:relations_to).class_name(:PostRelation).with_foreign_key(:to_id).inverse_of(:to).dependent(:destroy) }
    it { is_expected.to have_many(:relationing).through(:relations_from).source(:to) }
    it { is_expected.to have_many(:relationed).through(:relations_to).source(:from) }

    it { is_expected.to have_many(:comments).dependent(:destroy) }

    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:category).optional }
    it { is_expected.to belong_to(:custom_folder).optional }
    it { is_expected.to belong_to(:author).class_name('User').with_foreign_key('user_id') }
    it { is_expected.to belong_to(:last_editor).class_name('User').with_foreign_key('last_editor_id').optional }
  end

  describe 'association scope' do
    describe 'visible_attribute_values' do
      subject { post.visible_attribute_values }

      let(:project) { create(:project) }

      let(:visible_word_attribute_item) { create(:attribute_item, :word_group) }
      let(:invisible_word_attribute_item) { create(:attribute_item, :word_group) }
      let(:visible_character_attribute_item) { create(:attribute_item, :character_group) }
      let(:invisible_character_attribute_item) { create(:attribute_item, :character_group) }

      let!(:visible_word_attribute_value) { create(:attribute_value, :with_string, post: post, project: project, item: visible_word_attribute_item, is_visible: :visible) }
      let!(:invisible_word_attribute_value) { create(:attribute_value, :with_string, post: post, project: project, item: invisible_word_attribute_item, is_visible: :invisible) }
      let!(:visible_character_attribute_value) { create(:attribute_value, :with_string, post: post, project: project, item: visible_character_attribute_item, is_visible: :visible) }
      let!(:invisible_character_attribute_value) { create(:attribute_value, :with_string, post: post, project: project, item: invisible_character_attribute_item, is_visible: :invisible) }

      let(:post) { create(:post, :with_word, project: project) }

      it { is_expected.to include visible_word_attribute_value }
      it { is_expected.not_to include invisible_word_attribute_value }
      it { is_expected.not_to include visible_character_attribute_value }
      it { is_expected.not_to include invisible_character_attribute_value }
    end
  end

  describe 'enum' do
    it do
      is_expected.to define_enum_for(:status)
        .with_values(deleted: -1, published: 0, protect: 1, draft: 2, requesting: 3)
    end
    it do
      is_expected.to define_enum_for(:disclosure_range)
        .with_values(followers_only: 0, editors_only: 1, administrators_only: 2)
        .with_prefix(true)
    end
  end

  describe 'validation' do
    subject { build(:post) }

    describe 'term_id' do
      it { is_expected.to validate_presence_of(:term_id) }
      it { is_expected.to validate_length_of(:term_id).is_at_least(length.term_id.min).is_at_most(length.term_id.max) }
      it { is_expected.to validate_uniqueness_of(:term_id).scoped_to(:project_id) }
      it { is_expected.to allow_value('term_id').for(:term_id) }
      it { is_expected.to allow_value('_term_id8888').for(:term_id) }
      it { is_expected.not_to allow_value('たーむあいでぃー').for(:term_id) }
      it { is_expected.not_to allow_value('term@id').for(:term_id) }
      it { is_expected.not_to allow_value('term-id').for(:term_id) }
    end

    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_least(length.name.min).is_at_most(length.name.max) }
    end

    describe 'kana' do
      it { is_expected.to validate_length_of(:kana).is_at_least(length.kana.min).is_at_most(length.kana.max) }
      it { is_expected.to allow_value('よみがな').for(:kana) }
      it { is_expected.to allow_value('kana').for(:kana) }
      it { is_expected.to allow_value('kana1234').for(:kana) }
      it { is_expected.not_to allow_value('ヨミガナ').for(:kana) }
      it { is_expected.not_to allow_value('読み仮名').for(:kana) }
      it { is_expected.not_to allow_value('よみがな@').for(:kana) }
      it { is_expected.not_to allow_value(' かな').for(:kana) }
    end

    describe 'synopsis' do
      it { is_expected.to validate_length_of(:synopsis).is_at_least(length.synopsis.min).is_at_most(length.synopsis.max).allow_blank }
    end

    describe 'status' do
      it { is_expected.to allow_value(:published).for(:status) }
      it { is_expected.to allow_value(:protect).for(:status) }
      it { is_expected.to allow_value(:draft).for(:status) }
      it { is_expected.to allow_value(:deleted).for(:status) }
    end

    describe 'disclosure_range' do
      describe 'status check' do
        subject { build(:post, status) }

        context 'if published' do
          let(:status) { :published }

          it { is_expected.to allow_value(nil).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:followers_only).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:editors_only).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:administrators_only).for(:disclosure_range) }
        end

        context 'if protect' do
          let(:status) { :protect }

          it { is_expected.not_to allow_value(nil).for(:disclosure_range) }
          it { is_expected.to allow_value(:followers_only).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:editors_only).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:administrators_only).for(:disclosure_range) }

          pending { is_expected.to allow_value(:editors_only).for(:disclosure_range) }
          pending { is_expected.to allow_value(:administrators_only).for(:disclosure_range) }
        end

        context 'if draft' do
          let(:status) { :draft }

          it { is_expected.to allow_value(nil).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:followers_only).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:editors_only).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:administrators_only).for(:disclosure_range) }
        end

        context 'if deleted' do
          let(:status) { :deleted }

          it { is_expected.to allow_value(nil).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:followers_only).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:editors_only).for(:disclosure_range) }
          it { is_expected.not_to allow_value(:administrators_only).for(:disclosure_range) }
        end
      end
    end

    describe 'custom_folder_id' do
      context 'if custom' do
        before { allow(subject).to receive(:custom).and_return(true) }
        it { is_expected.to validate_presence_of(:custom_folder_id) }
      end

      context 'if other kind' do
        before { allow(subject).to receive(:custom).and_return(false) }
        it { is_expected.to validate_absence_of(:custom_folder_id) }
      end
    end
  end

  describe 'post child' do
    context 'どちらにも値がある場合' do
      let(:post) { build(:post, :with_multi) }

      it { is_expected.to be_invalid }
    end

    context 'どちらにも値がない場合' do
      let(:post) { build(:post, :with_nil) }

      it { is_expected.to be_invalid }
    end
  end

  describe 'author' do
    let(:post) { build(:post, author: author) }

    context '値がない場合' do
      let(:author) { nil }

      it { is_expected.to be_invalid }
    end
  end

  describe 'project' do
    let(:post) { build(:post, project: project) }

    context '値がない場合' do
      let(:project) { nil }

      it { is_expected.to be_invalid }
    end
  end

  describe 'category' do
    subject { post }
    let(:project) { create(:project) }
    let(:post) { build(:post, :with_word, project: project, category: category) }

    context '同じ種類の場合' do
      let(:category) { create(:category, :word, project: project) }

      it { is_expected.to be_valid }
    end

    context '別の種類の場合' do
      let(:category) { create(:category, :character, project: project) }

      it { is_expected.to be_invalid }
    end

    context '別のプロジェクトの場合' do
      let(:category) { create(:category, :character, project: create(:project)) }

      it { is_expected.to be_invalid }
    end
  end

  describe 'custom_folder' do
    subject { post.invalid? }

    describe 'check required' do
      describe 'with custom' do
        let(:post) { build(:post, :with_custom) }

        context 'custom_folder nil' do
          before do
            post.custom_folder = nil
          end

          it { is_expected.to be_truthy }
        end

        context 'custom_folder exist' do
          it { is_expected.to be_falsey }
        end
      end

      describe 'with not custom' do
        let(:project) { create(:project) }
        let(:post) { build(:post, :with_word, project: project) }

        context 'custom_folder nil' do
          it { is_expected.to be_falsey }
        end

        context 'custom_folder exist' do
          before do
            post.custom_folder = create(:custom_folder, project: project)
          end

          it {
            is_expected.to be_truthy }
        end
      end
    end

    describe 'check match project' do
      subject { post.invalid? }
      let(:project) { create(:project) }
      let(:post) { build(:post, :with_custom, project: project, custom_folder: custom_folder) }

      context '同じプロジェクトの場合' do
        let(:custom_folder) { create(:custom_folder, project: project) }

        it { is_expected.to be_falsey }
      end

      context '別のプロジェクトの場合' do
        let(:custom_folder) { create(:custom_folder, project: create(:project)) }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe 'duplicate check' do
    subject { post.invalid? }

    let(:project) { create(:project) }

    describe 'term_id' do
      before {
        create(:post, term_id: term_id, project: exist_project)
      }

      let(:term_id) { 'duplicate_name' }
      let(:post) { build(:post, term_id: term_id, project: project) }

      context '同じプロジェクトの場合' do
        let(:exist_project) { project }

        it { is_expected.to be_truthy }
      end

      context '別プロジェクトの場合' do
        let(:exist_project) { create(:project) }

        it { is_expected.to be_falsey }
      end
    end

    describe 'name' do
      before {
        create(:post, :with_word, name: name, project: exist_project)
      }

      let(:name) { 'duplicate_name' }

      describe '同じ種類の場合' do
        let(:post) { build(:post, :with_word, name: name, project: project) }

        context '同じプロジェクトの場合' do
          let(:exist_project) { project }

          it { is_expected.to be_truthy }
        end

        context '別プロジェクトの場合' do
          let(:exist_project) { create(:project) }

          it { is_expected.to be_falsey }
        end
      end

      describe '別種類の場合' do
        let(:post) { build(:post, :with_character, name: name, project: project) }

        context '同じプロジェクトの場合' do
          let(:exist_project) { project }

          it { is_expected.to be_falsey }
        end
      end
    end
  end

  describe '#kind' do
    subject { post.kind }

    context 'wordの場合' do
      let(:post) { create(:post, :with_word) }

      it { is_expected.to eq 'word' }
    end

    context 'characterの場合' do
      let(:post) { create(:post, :with_character) }

      it { is_expected.to eq 'character' }
    end

    context 'customの場合' do
      let(:post) { create(:post, :with_custom) }

      it { is_expected.to eq 'custom' }
    end
  end

  describe '#set_last_editor' do
    let(:author) { create(:user) }
    let(:post) { build(:post, last_editor: editor, author: author) }

    context '空の場合' do
      let(:editor) { nil }

      example '投稿者が自動で入る' do
        post.validate
        expect(post.last_editor).to eq author
      end
    end
  end

  describe 'viewable_for?' do
    let(:author) { create(:user) }

    let(:project) { create(:project, is_published: is_published, author: project_author) }
    let(:project_author) { create(:user) }

    let!(:my_published_post) { create(:post, :published, project: project, author: author) }
    let!(:my_protect_post) { create(:post, :protect, project: project, author: author) }
    let!(:my_draft_post) { create(:post, :draft, project: project, author: author) }
    let!(:my_requesting_post) { create(:post, :requesting, project: project, author: author) }
    let!(:my_deleted_post) { create(:post, :deleted, project: project, author: author) }

    let!(:published_post) { create(:post, :published, project: project) }
    let!(:protect_post) { create(:post, :protect, project: project) }
    let!(:draft_post) { create(:post, :draft, project: project) }
    let!(:requesting_post) { create(:post, :requesting, project: project) }
    let!(:deleted_post) { create(:post, :deleted, project: project) }

    describe 'published project' do
      let(:is_published) { :published }

      describe 'user is admin' do
        let(:project_author) { author }

        it { expect(my_published_post.viewable_for?(author)).to be_truthy }
        it { expect(my_protect_post.viewable_for?(author)).to be_truthy }
        it { expect(my_draft_post.viewable_for?(author)).to be_truthy }
        it { expect(my_requesting_post.viewable_for?(author)).to be_truthy }
        it { expect(my_deleted_post.viewable_for?(author)).to be_truthy }

        it { expect(published_post.viewable_for?(author)).to be_truthy }
        it { expect(protect_post.viewable_for?(author)).to be_truthy }
        it { expect(draft_post.viewable_for?(author)).to be_falsey }
        it { expect(requesting_post.viewable_for?(author)).to be_truthy }
        it { expect(deleted_post.viewable_for?(author)).to be_truthy }
      end

      describe 'user is editor' do
        before do
          create(:project_follower, project: project, user: author, permission: :edit, approval: :approved)
        end

        it { expect(my_published_post.viewable_for?(author)).to be_truthy }
        it { expect(my_protect_post.viewable_for?(author)).to be_truthy }
        it { expect(my_draft_post.viewable_for?(author)).to be_truthy }
        it { expect(my_requesting_post.viewable_for?(author)).to be_truthy }
        it { expect(my_deleted_post.viewable_for?(author)).to be_truthy }

        it { expect(published_post.viewable_for?(author)).to be_truthy }
        it { expect(protect_post.viewable_for?(author)).to be_truthy }
        it { expect(draft_post.viewable_for?(author)).to be_falsey }
        it { expect(requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(deleted_post.viewable_for?(author)).to be_truthy }
      end

      describe 'user is viewer' do
        before do
          create(:project_follower, project: project, user: author, permission: :view, approval: :approved)
        end

        it { expect(my_published_post.viewable_for?(author)).to be_truthy }
        it { expect(my_protect_post.viewable_for?(author)).to be_truthy }
        it { expect(my_draft_post.viewable_for?(author)).to be_falsey }
        it { expect(my_requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(my_deleted_post.viewable_for?(author)).to be_falsey }

        it { expect(published_post.viewable_for?(author)).to be_truthy }
        it { expect(protect_post.viewable_for?(author)).to be_truthy }
        it { expect(draft_post.viewable_for?(author)).to be_falsey }
        it { expect(requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(deleted_post.viewable_for?(author)).to be_falsey }
      end

      describe 'user is guest' do
        it { expect(my_published_post.viewable_for?(author)).to be_truthy }
        it { expect(my_protect_post.viewable_for?(author)).to be_falsey }
        it { expect(my_draft_post.viewable_for?(author)).to be_falsey }
        it { expect(my_requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(my_deleted_post.viewable_for?(author)).to be_falsey }

        it { expect(published_post.viewable_for?(author)).to be_truthy }
        it { expect(protect_post.viewable_for?(author)).to be_falsey }
        it { expect(draft_post.viewable_for?(author)).to be_falsey }
        it { expect(requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(deleted_post.viewable_for?(author)).to be_falsey }
      end
    end

    describe 'protect project' do
      let(:is_published) { :protect }

      describe 'user is admin' do
        let(:project_author) { author }

        it { expect(my_published_post.viewable_for?(author)).to be_truthy }
        it { expect(my_protect_post.viewable_for?(author)).to be_truthy }
        it { expect(my_draft_post.viewable_for?(author)).to be_truthy }
        it { expect(my_requesting_post.viewable_for?(author)).to be_truthy }
        it { expect(my_deleted_post.viewable_for?(author)).to be_truthy }

        it { expect(published_post.viewable_for?(author)).to be_truthy }
        it { expect(protect_post.viewable_for?(author)).to be_truthy }
        it { expect(draft_post.viewable_for?(author)).to be_falsey }
        it { expect(requesting_post.viewable_for?(author)).to be_truthy }
        it { expect(deleted_post.viewable_for?(author)).to be_truthy }
      end

      describe 'user is editor' do
        before do
          create(:project_follower, project: project, user: author, permission: :edit, approval: :approved)
        end

        it { expect(my_published_post.viewable_for?(author)).to be_truthy }
        it { expect(my_protect_post.viewable_for?(author)).to be_truthy }
        it { expect(my_draft_post.viewable_for?(author)).to be_truthy }
        it { expect(my_requesting_post.viewable_for?(author)).to be_truthy }
        it { expect(my_deleted_post.viewable_for?(author)).to be_truthy }

        it { expect(published_post.viewable_for?(author)).to be_truthy }
        it { expect(protect_post.viewable_for?(author)).to be_truthy }
        it { expect(draft_post.viewable_for?(author)).to be_falsey }
        it { expect(requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(deleted_post.viewable_for?(author)).to be_truthy }
      end

      describe 'user is viewer' do
        before do
          create(:project_follower, project: project, user: author, permission: :view, approval: :approved)
        end

        it { expect(my_published_post.viewable_for?(author)).to be_truthy }
        it { expect(my_protect_post.viewable_for?(author)).to be_truthy }
        it { expect(my_draft_post.viewable_for?(author)).to be_falsey }
        it { expect(my_requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(my_deleted_post.viewable_for?(author)).to be_falsey }

        it { expect(published_post.viewable_for?(author)).to be_truthy }
        it { expect(protect_post.viewable_for?(author)).to be_truthy }
        it { expect(draft_post.viewable_for?(author)).to be_falsey }
        it { expect(requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(deleted_post.viewable_for?(author)).to be_falsey }
      end

      describe 'user is requesting' do
        before do
          create(:project_follower, project: project, user: author, permission: :edit, approval: :unapproved)
        end

        it { expect(my_published_post.viewable_for?(author)).to be_falsey }
        it { expect(my_protect_post.viewable_for?(author)).to be_falsey }
        it { expect(my_draft_post.viewable_for?(author)).to be_falsey }
        it { expect(my_requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(my_deleted_post.viewable_for?(author)).to be_falsey }

        it { expect(published_post.viewable_for?(author)).to be_falsey }
        it { expect(protect_post.viewable_for?(author)).to be_falsey }
        it { expect(draft_post.viewable_for?(author)).to be_falsey }
        it { expect(requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(deleted_post.viewable_for?(author)).to be_falsey }
      end

      describe 'user is guest' do
        it { expect(my_published_post.viewable_for?(author)).to be_falsey }
        it { expect(my_protect_post.viewable_for?(author)).to be_falsey }
        it { expect(my_draft_post.viewable_for?(author)).to be_falsey }
        it { expect(my_requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(my_deleted_post.viewable_for?(author)).to be_falsey }

        it { expect(published_post.viewable_for?(author)).to be_falsey }
        it { expect(protect_post.viewable_for?(author)).to be_falsey }
        it { expect(draft_post.viewable_for?(author)).to be_falsey }
        it { expect(requesting_post.viewable_for?(author)).to be_falsey }
        it { expect(deleted_post.viewable_for?(author)).to be_falsey }
      end
    end
  end

  describe 'type scope' do
    let!(:word_post) { create(:post, :with_word) }
    let!(:character_post) { create(:post, :with_character) }
    let!(:custom_post) { create(:post, :with_custom) }
    let!(:other_custom_post) { create(:post, :with_custom) }

    context '#words' do
      subject { Post.words }

      it { is_expected.to include word_post }
      it { is_expected.not_to include character_post }
      it { is_expected.not_to include custom_post }
      it { is_expected.not_to include other_custom_post }
    end

    context '#character' do
      subject { Post.characters }

      it { is_expected.not_to include word_post }
      it { is_expected.to include character_post }
      it { is_expected.not_to include custom_post }
      it { is_expected.not_to include other_custom_post }
    end

    context '#custom_as' do
      subject { Post.customs_as custom_post.custom_folder.term_id }

      it { is_expected.not_to include word_post }
      it { is_expected.not_to include character_post }
      it { is_expected.to include custom_post }
      it { is_expected.not_to include other_custom_post }
    end
  end

  describe '#setable_attribute?' do
    subject { post.setable_attribute?(attr) }
    let(:project) { create(:project) }
    let(:post) { build(:post, project: project) }

    context '同じプロジェクトのAttrの場合' do
      before do
        project.attribute_items << attr
      end

      let(:attr) { create(:attribute_item) }

      it { is_expected.to be_truthy }
    end

    context '他プロジェクトのAttrの場合' do
      before do
        other_project.attribute_items << attr
      end

      let(:other_project) { create(:project) }
      let(:attr) { create(:attribute_item) }

      it { is_expected.to be_falsey }
    end
  end
end
