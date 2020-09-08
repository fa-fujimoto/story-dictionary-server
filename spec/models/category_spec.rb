require 'rails_helper'

params_length = Category::PARAMS_LENGTH

RSpec.describe Category, type: :model do
  let(:project) { create(:project) }

  describe 'validation' do
    subject { category.invalid? }

    describe 'max' do
      let(:category) { build(:category_max) }

      it { is_expected.to be_falsey }
    end

    describe 'min' do
      let(:category) { build(:category_min) }

      it { is_expected.to be_falsey }
    end

    describe 'term_id' do
      let(:category) { build(:category, term_id: term_id, project: project) }

      context '空の場合' do
        let(:term_id) { nil }

        it { is_expected.to be_truthy }
      end

      context "規定文字数以上の場合" do
        let(:term_id) { 'a' * (params_length.term_id.max + 1) }

        it { is_expected.to be_truthy }
      end

      context "規定文字数以下の場合" do
        let(:term_id) { 'a' * (params_length.term_id.min - 1) }

        it { is_expected.to be_truthy }
      end

      describe '重複チェック' do
        before do
          create(:category, term_id: term_id, project: exist_project)
        end

        let(:term_id) { 'duplicate_term' }

        context '同じプロジェクトの場合' do
          let(:exist_project) { project }

          it { is_expected.to be_truthy }
        end

        context '別プロジェクトの場合' do
          let(:exist_project) { create(:project) }

          it { is_expected.to be_falsey }
        end
      end
    end

    describe 'name' do
      let(:category) { build(:category, name: name, project: project) }

      context '空の場合' do
        let(:name) { nil }

        it { is_expected.to be_truthy }
      end

      context "規定文字数以上の場合" do
        let(:name) { 'a' * (params_length.name.max + 1) }

        it { is_expected.to be_truthy }
      end

      context "規定文字数以下の場合" do
        let(:name) { 'a' * (params_length.name.min - 1) }

        it { is_expected.to be_truthy }
      end

      context '値がある場合' do
        let(:name) { 'test_name' }

        it { is_expected.to be_falsey }
      end

      describe '重複チェック' do
        before do
          create(:category, name: name, kind: kind, project: exist_project)
        end

        let(:name) { 'duplicate_name' }

        context '同じプロジェクト' do
          let(:exist_project) { project }

          context 'kindが一致の場合' do
            let(:kind) { 'word' }
            it { is_expected.to be_truthy }
          end

          context 'kindが不一致の場合' do
            let(:kind) { 'character' }
            it { is_expected.to be_falsey }
          end
        end

        context '別プロジェクト' do
          let(:exist_project) { create(:project) }

          context 'kindが一致の場合' do
            let(:kind) { 'word' }
            it { is_expected.to be_falsey }
          end

          context 'kindが不一致の場合' do
            let(:kind) { 'character' }
            it { is_expected.to be_falsey }
          end
        end
      end
    end

    describe 'synopsis' do
      let(:category) { build(:category, synopsis: synopsis) }

      context "規定文字数以上の場合" do
        let(:synopsis) { 'a' * (params_length.synopsis.max + 1) }

        it { is_expected.to be_truthy }
      end
    end

    describe 'body' do
      let(:category) { build(:category, body: body) }

      context "規定文字数以上の場合" do
        let(:body) { 'a' * (params_length.body.max + 1) }

        it { is_expected.to be_truthy }
      end
    end

    describe 'kind' do
      let(:category) { build(:category, kind: kind) }

      context '規定外の値の場合' do
        let(:kind) { 'miss_kind' }

        it { is_expected.to be_truthy }
      end
    end

    describe 'project' do
      let(:category) { build(:category, project: project) }

      context '空の場合' do
        let(:project) { nil }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe 'scope' do
    let(:word_category) { create(:category, kind: 'word') }
    let(:character_category) { create(:category, kind: 'character') }

    describe '#word' do
      subject { Category.word }

      it { is_expected.to include word_category }
      it { is_expected.not_to include character_category }
    end

    describe '#character' do
      subject { Category.character }

      it { is_expected.not_to include word_category }
      it { is_expected.to include character_category }
    end
  end
end
