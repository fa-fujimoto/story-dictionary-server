require 'rails_helper'

RSpec.describe AttributeConfig, type: :model do
  describe 'validate' do
    subject { config.invalid? }

    describe 'normal pattern' do
      let(:config) { build(:attribute_config, :with_custom) }

      it { is_expected.to be_falsey }
    end

    describe 'item_id' do
      before {
        create(:attribute_config, item: item, project: exist_project)
      }

      let(:item) { create(:attribute_item) }
      let(:project) { create(:project) }
      let(:config) { build(:attribute_config, item: item, project: project) }

      context '同じプロジェクトの場合' do
        let(:exist_project) { project }

        it { is_expected.to be_truthy }
      end

      context '別プロジェクトの場合' do
        let(:exist_project) { create(:project) }

        it { is_expected.to be_falsey }
      end
    end

    describe 'is_visible' do
      let(:config) { build(:attribute_config, is_visible: is_visible) }

      context 'nil' do
        let(:is_visible) { nil }

        it { is_expected.to be_truthy }
      end
    end

    describe 'check_item_name' do
      before {
        create(:attribute_config, item: create(:attribute_item, name: name), project: exist_project)
      }

      let(:name) { 'duplicate_name' }
      let(:project) { create(:project) }
      let(:config) { build(:attribute_config, item: create(:attribute_item, name: name), project: project) }

      context 'same project' do
        let(:exist_project) { project }

        it { is_expected.to be_truthy }
      end

      context 'other project' do
        let(:exist_project) { create(:project) }

        it { is_expected.to be_falsey }
      end
    end
  end

  describe 'scope' do
    let!(:word_config) { create(:attribute_config, :with_word) }
    let!(:character_config) { create(:attribute_config, :with_character) }
    let!(:custom_config) { create(:attribute_config, :with_custom, custom_folder_term_id: 'custom_folder') }
    let!(:other_custom_config) { create(:attribute_config, :with_custom, custom_folder_term_id: 'other_custom_folder') }

    describe '#visible_to_word' do
      subject { AttributeConfig.visible_to_word }

      it { is_expected.to include word_config }
      it { is_expected.not_to include character_config }
      it { is_expected.not_to include custom_config }
      it { is_expected.not_to include other_custom_config }
    end

    describe '#visible_to_character' do
      subject { AttributeConfig.visible_to_character }

      it { is_expected.not_to include word_config }
      it { is_expected.to include character_config }
      it { is_expected.not_to include custom_config }
      it { is_expected.not_to include other_custom_config }
    end

    describe '#visible_to_custom_as' do
      subject { AttributeConfig.visible_to_custom_as 'custom_folder' }

      it { is_expected.not_to include word_config }
      it { is_expected.not_to include character_config }
      it { is_expected.to include custom_config }
      it { is_expected.not_to include other_custom_config }
    end
  end
end
