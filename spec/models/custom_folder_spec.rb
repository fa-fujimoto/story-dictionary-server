require 'rails_helper'

length = CustomFolder::PARAMS_LENGTH

RSpec.describe CustomFolder, type: :model do
  describe 'enum' do
    it do
      is_expected.to define_enum_for(:is_visible)
        .with_values(visible: true, invisible: false)
        .backed_by_column_of_type(:boolean)
    end
  end

  describe 'validation' do
    subject { custom_folder.invalid? }

    describe 'min max pattern' do
      context 'Normal' do
        let(:custom_folder) { build(:custom_folder) }
        it { is_expected.to be_falsey }
      end

      context 'max' do
        let(:custom_folder) { build(:custom_folder, :max) }
        it { is_expected.to be_falsey }
      end

      context 'min' do
        let(:custom_folder) { build(:custom_folder, :min) }
        it { is_expected.to be_falsey }
      end
    end

    describe 'term_id' do
      let(:custom_folder) { build(:custom_folder, term_id: term_id) }

      context '値が存在しない場合' do
        let(:term_id) { nil }

        it { is_expected.to be_truthy }
      end

      context '全角文字が含まれる場合' do
        let(:term_id) { 'タームあいでぃー' }

        it { is_expected.to be_truthy }
      end

      context '区切り記号が含まれる場合' do
        let(:term_id) { 'project_name_test' }

        it { is_expected.to be_falsey }
      end

      context '許容外の記号が含まれる場合' do
        let(:term_id) { 'project@name*test' }

        it { is_expected.to be_truthy }
      end

      context '上限以上' do
        let(:term_id) { 'a' * ( length.term_id.max + 1 ) }

        it { is_expected.to be_truthy }
      end

      context '下限以下' do
        let(:term_id) { 'a' * ( length.term_id.min - 1 ) }

        it { is_expected.to be_truthy }
      end
    end

    describe 'name' do
      let(:custom_folder) { build(:custom_folder, name: name) }

      context '名前がない場合' do
        let(:name) {nil}

        it { is_expected.to be_truthy }
      end

      context '上限以上' do
        let(:name) { 'a' * ( length.name.max + 1 ) }

        it { is_expected.to be_truthy }
      end

      context '下限以下' do
        let(:name) { 'a' * ( length.name.min - 1 ) }

        it { is_expected.to be_truthy }
      end
    end

    describe 'is_visible' do
      subject { build(:custom_folder) }

      it { is_expected.to allow_value(:visible).for(:is_visible) }
      it { is_expected.to allow_value(:invisible).for(:is_visible) }
      it { is_expected.not_to allow_value(nil).for(:is_visible) }
    end

    describe 'project_id' do
      let(:custom_folder) { build(:custom_folder, project: project) }

      context '空の場合' do
        let(:project) { nil }

        it { is_expected.to be_truthy }
      end
    end

    describe 'uniqueness' do
      let(:custom_folder) { build(:custom_folder, term_id: term_id, name: name, project: project) }
      let(:term_id) { 'term_id' }
      let(:name) { 'name' }
      let(:project) { create(:project) }

      before do
        create(:custom_folder, term_id: exist_term_id, name: exist_name, project: exist_project)
      end

      describe '同じプロジェクト' do
        let(:exist_project) { project }

        describe 'term_id' do
          let(:exist_name) { 'other_name' }

          context '重複している場合' do
            let(:exist_term_id) { term_id }

            it { is_expected.to be_truthy }
          end

          context '重複していない場合' do
            let(:exist_term_id) { 'other_term_id' }

            it { is_expected.to be_falsey }
          end
        end

        describe 'name' do
          let(:exist_term_id) { 'other_term_id' }

          context '重複している場合' do
            let(:exist_name) { name }

            it { is_expected.to be_truthy }
          end

          context '重複していない場合' do
            let(:exist_name) { 'other_name' }

            it { is_expected.to be_falsey }
          end
        end
      end

      describe '別プロジェクト' do
        let(:exist_project) { create(:project) }

        describe 'term_id' do
          let(:exist_name) { 'other_name' }

          context '重複している場合' do
            let(:exist_term_id) { term_id }

            it { is_expected.to be_falsey }
          end

          context '重複していない場合' do
            let(:exist_term_id) { 'other_term_id' }

            it { is_expected.to be_falsey }
          end
        end

        describe 'name' do
          let(:exist_term_id) { 'other_term_id' }

          context '重複している場合' do
            let(:exist_name) { name }

            it { is_expected.to be_falsey }
          end

          context '重複していない場合' do
            let(:exist_name) { 'other_name' }

            it { is_expected.to be_falsey }
          end
        end
      end
    end
  end
end
