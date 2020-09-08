require 'rails_helper'

RSpec.describe AttributeOption, type: :model do
  describe 'validate' do
    subject { option.invalid? }

    describe 'name' do
      let(:option) { build(:attribute_option, name: name) }

      context 'nil' do
        let(:name) { nil }

        it { is_expected.to be_truthy }
      end

      describe 'length' do
        let(:name) { 'a' * length }

        context 'over max' do
          let(:length) { 31 }

          it { is_expected.to be_truthy }
        end

        context 'over min' do
          let(:length) { 0 }

          it { is_expected.to be_truthy }
        end
      end

      describe 'uniqueness' do
        before {
          create(:attribute_option, name: name, item: exist_item)
          option.item = item
        }

        let(:name) { 'duplicate_name' }
        let(:item) { create(:attribute_item, :select_item) }

        context 'same item' do
          let(:exist_item) { item }

          it { is_expected.to be_truthy }
        end

        context 'other item' do
          let(:exist_item) { create(:attribute_item, :select_item) }

          it { is_expected.to be_falsey }
        end
      end
    end

    describe 'value' do
      let(:option) { build(:attribute_option, value: value) }

      context 'nil' do
        let(:value) { nil }

        it { is_expected.to be_truthy }
      end

      describe 'length' do
        let(:option) { build(:attribute_option, value: value, item: item) }

        describe 'boolean' do
          let(:item) { build(:attribute_item, :boolean_item) }

          context 'over max' do
            let(:value) { 2 }

            it { is_expected.to be_truthy }
          end

          context 'over min' do
            let(:value) { -1 }

            it { is_expected.to be_truthy }
          end
        end

        describe 'select' do
          let(:item) { build(:attribute_item, :select_item) }

          context 'over min' do
            let(:value) { -1 }

            it { is_expected.to be_truthy }
          end
        end
      end

      describe 'uniqueness' do
        before {
          create(:attribute_option, value: value, item: exist_item)
          option.item = item
        }

        let(:value) { 0 }
        let(:item) { create(:attribute_item, :boolean_item) }

        context 'same item' do
          let(:exist_item) { item }

          it { is_expected.to be_truthy }
        end

        context 'other item' do
          let(:exist_item) { create(:attribute_item, :boolean_item) }

          it { is_expected.to be_falsey }
        end
      end
    end

    describe 'item' do
      let(:option) { build(:attribute_option, item: item) }

      context 'nil' do
        let(:item) { nil }

        it { is_expected.to be_truthy }
      end

      context 'string item' do
        let(:item) { create(:attribute_item, :string_item) }

        it { is_expected.to be_truthy }
      end
    end

    describe 'options_count_must_be_within_limit' do
      before { create_list(:attribute_option, length) }
      let(:option) { build(:attribute_option, item: item) }

      describe 'boolean' do
        let(:item) { create(:attribute_item, :boolean_item) }

        context 'over upper limit' do
          let(:length) { 2 }

          it { is_expected.to be_truthy }
        end

        context 'over under limit' do
          let(:length) { 0 }

          it { is_expected.to be_truthy }
        end

        context 'within limit' do
          let(:length) { 1 }

          it { is_expected.to be_truthy }
        end
      end
    end
  end
end
