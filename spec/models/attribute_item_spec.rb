require 'rails_helper'

RSpec.describe AttributeItem, type: :model do
  describe 'normal pattern' do
    subject { attribute_item.invalid? }
    let(:attribute_item) { build(:attribute_item, :custom_group) }

    it { is_expected.to be_falsey }
  end

  describe 'name' do
    subject { build(:attribute_item, name: name) }

    context '名前が規定文字数以内の場合' do
      let(:name) { 'a' * 100 }

      it { is_expected.not_to be_invalid }
    end

    context '名前が存在しない場合' do
      let(:name) { nil }

      it { is_expected.to be_invalid }
    end

    context '名前が空の場合' do
      let(:name) { '' }

      it { is_expected.to be_invalid }
    end

    context '名前がアルファベット51文字以上の場合' do
      let(:name) { 'a' * 101 }

      it { is_expected.to be_invalid }
    end

    context '名前が全角文字51文字以上の場合' do
      let(:name) { 'あ' * 101 }

      it { is_expected.to be_invalid }
    end
  end

  describe 'kind' do
    subject { build(:attribute_item, kind: kind) }

    context '空の場合' do
      let(:kind) { nil }

      it { is_expected.to be_invalid }
    end
  end


  describe 'group' do
    subject { build(:attribute_item, group: group) }

    context '空の場合' do
      let(:group) { nil }

      it { is_expected.to be_invalid }
    end
  end

  describe 'required' do
    subject { build(:attribute_item, required: required) }

    context '空の場合' do
      let(:required) { nil }

      it { is_expected.to be_invalid }
    end
  end

  describe 'default_item' do
    subject { build(:attribute_item, default_item: default_item) }

    context '空の場合' do
      let(:default_item) { nil }

      it { is_expected.to be_invalid }
    end
  end

  describe 'custom_folder_id' do
    subject { build(:attribute_item, group: group, custom_folder: nil) }

    context 'default group' do
      let(:group) { 0 }

      it { is_expected.not_to be_invalid }
    end

    context 'custom group' do
      let(:group) { 99 }

      it { is_expected.to be_invalid }
    end
  end

  describe 'custom_folder_id' do
    subject { build(:attribute_item, group: group, custom_folder: nil) }

    context 'default group' do
      let(:group) { 0 }

      it { is_expected.not_to be_invalid }
    end

    context 'custom group' do
      let(:group) { 99 }

      it { is_expected.to be_invalid }
    end
  end

  describe 'options' do
    subject { item.invalid? }

    describe 'boolean' do
      context 'none option' do
        let(:item) { create(:attribute_item, :boolean_item) }

        it { is_expected.to be_truthy }
      end

      context 'one option' do
        let(:item) { create(:attribute_item, :boolean_item) }

        before { create(:attribute_option, item: item) }

        it { is_expected.to be_truthy }
      end

      context 'two option' do
        let(:item) { create(:attribute_item, :boolean_item, :with_options) }

        it { is_expected.to be_falsey }
      end
    end

    describe 'select' do
      context 'none option' do
        let(:item) { create(:attribute_item, :select_item) }

        it { is_expected.to be_truthy }
      end

      context 'one option' do
        let(:item) { create(:attribute_item, :select_item) }

        before { create(:attribute_option, item: item) }

        it { is_expected.to be_falsey }
      end

      context 'two option' do
        let(:item) { create(:attribute_item, :select_item, :with_options) }

        it { is_expected.to be_falsey }
      end

      context 'three option' do
        let(:item) { create(:attribute_item, :select_item) }

        before {
          create(:attribute_option, value: 0, item: item)
          create(:attribute_option, value: 1, item: item)
          create(:attribute_option, value: 2, item: item)
        }

        it { is_expected.to be_falsey }
      end
    end
  end

  describe 'group_scope' do
    let!(:word_attribute) { create(:attribute_item, group: 0) }
    let!(:character_attribute) { create(:attribute_item, group: 1) }

    describe '#belong_to_word' do
      subject { AttributeItem.belong_to_word }

      it { is_expected.to include word_attribute }
      it { is_expected.not_to include character_attribute }
    end

    describe '#belong_to_character' do
      subject { AttributeItem.belong_to_character }

      it { is_expected.not_to include word_attribute }
      it { is_expected.to include character_attribute }
    end
  end

  describe '#setable_name_for?' do
    subject { create(:attribute_item, name: name, group: group).setable_name_for?(project) }
    let(:project) { create(:project) }
    let(:exist_item) { create(:attribute_item, name: exist_name, group: exist_group) }
    let(:name) { 'duplicate_name' }
    let(:group) { 0 }

    before {
      create(:attribute_config, project: project, item: exist_item)
    }

    context '重複しない場合' do
      let(:exist_name) { 'exist_name' }
      let(:exist_group) { 1 }

      it { is_expected.to be_truthy }
    end

    context '名前だけ重複した場合' do
      let(:exist_name) { name }
      let(:exist_group) { 1 }

      it { is_expected.to be_truthy }
    end

    context 'groupだけ重複した場合' do
      let(:exist_name) { 'exist_name' }
      let(:exist_group) { group }

      it { is_expected.to be_truthy }
    end

    context '両方重複した場合' do
      let(:exist_name) { name }
      let(:exist_group) { group }

      it { is_expected.to be_falsey }
    end
  end
end
