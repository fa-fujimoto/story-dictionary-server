require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'db' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(index: true, null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:post_id).of_type(:integer).with_options(index: true, null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:comment_id).of_type(:integer).with_options(index: true, foreign_key: true) }
    it { is_expected.to have_db_column(:body).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:status).of_type(:integer).with_options(index: true, null: false) }
  end

  describe 'enum' do
    it do
      is_expected.to define_enum_for(:status)
        .with_values(deleted: -1, open: 0, requesting: 1)
    end
  end

  describe 'association' do
    it { is_expected.to belong_to(:author).class_name(:User).with_foreign_key(:user_id) }
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:reply_to).class_name(:Comment).with_foreign_key(:comment_id).inverse_of(:replies).optional }

    it { is_expected.to have_many(:replies).class_name(:Comment).with_foreign_key(:comment_id).inverse_of(:reply_to).dependent(:destroy) }
  end

  describe 'validation' do
    subject { build(:comment) }

    describe 'body' do
      it { is_expected.to validate_presence_of(:body) }
      it do
        is_expected.to validate_length_of(:body)
          .is_at_least(1)
          .is_at_most(10000)
      end
    end

    describe 'status' do
      it do
        is_expected.to allow_value(:open)
          .for(:status)
      end
      it do
        is_expected.to allow_value(:requesting)
          .for(:status)
      end
      it do
        is_expected.to allow_value(:deleted)
          .for(:status)
      end
    end
  end

  describe 'custom validation' do
  end

  describe '#status_auto_fix' do
    subject { comment.status }

    let(:post) { create(:post) }
    let(:comment) { build(:comment, post: post, status: status) }

    before do
      allow(post).to receive(:comment_release_soon?).and_return(comment_release_soon)

      comment.validate
    end

    describe 'comment release soon' do
      let(:comment_release_soon) { true }

      describe 'status is nil' do
        let(:status) { nil }

        it { is_expected.to eq 'open' }
      end

      describe 'status is open' do
        let(:status) { :open }

        it { is_expected.to eq 'open' }
      end

      describe 'status is requesting' do
        let(:status) { :requesting }

        it { is_expected.to eq 'open' }
      end
    end

    describe 'comment release after approval' do
      let(:comment_release_soon) { false }

      describe 'status is nil' do
        let(:status) { nil }

        it { is_expected.to eq 'requesting' }
      end

      describe 'status is open' do
        let(:status) { :open }

        it { is_expected.to eq 'requesting' }
      end

      describe 'status is requesting' do
        let(:status) { :requesting }

        it { is_expected.to eq 'requesting' }
      end
    end
  end

  describe '#belongs_to_same_post_for?' do
    subject { comment.belongs_to_same_post_for?(item) }

    let(:post) { create(:post) }
    let(:comment) { create(:comment, post: post) }
    let(:item) { create(:comment, post: reply_post) }

    context 'same post' do
      let(:reply_post) { post }

      it { is_expected.to be_truthy }
    end

    context 'other post' do
      let(:reply_post) { create(:post) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#replyable_for?' do
    subject { comment.replyable_for?(user) }

    let(:user) { create(:user) }
    let(:comment) { build(:comment, post: post, status: status) }
    let(:post) { create(:post) }

    before do
      allow(post).to receive(:replyable_for?).and_return(true)
    end

    context 'reply to deleted' do
      let(:status) { :deleted }

      it { is_expected.to be_falsey }
    end

    context 'reply to requesting' do
      let(:status) { :requesting }

      it { is_expected.to be_falsey }
    end

    context 'reply to open' do
      let(:status) { :open }

      it { is_expected.to be_truthy }
    end
  end

  describe '#destroy' do
    subject { comment }

    before do
      comment.destroy(with_children_delete?)
    end

    describe 'has children' do
      let(:post) { create(:post) }

      let(:reply) { create(:comment, post: post) }
      let(:comment) { create(:comment, post: post, replies: [reply]) }

      context 'children delete' do
        let(:with_children_delete?) { true }

        it { is_expected.to be_destroyed }
        it { expect(reply).to be_destroyed }
      end

      context 'children delete' do
        let(:with_children_delete?) { false }

        it { is_expected.to be_deleted }
        it { expect(reply).to be_open }
      end
    end

    describe 'has not children' do
      let(:comment) { create(:comment) }

      context 'children delete' do
        let(:with_children_delete?) { true }

        it { is_expected.to be_destroyed }
      end

      context 'children delete' do
        let(:with_children_delete?) { false }

        it { is_expected.to be_destroyed }
      end
    end
  end
end
