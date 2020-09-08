require 'rails_helper'

length = AttributeValue::PARAMS_LENGTH

RSpec.describe AttributeValue, type: :model do
  describe 'validate' do
    subject { attribute_value.invalid? }

    context '通常pattern' do
      let(:attribute_value) { build(:attribute_value, :with_string) }

      it { is_expected.to be_falsey }
    end

    describe 'post_id' do
      let(:project) { create(:project) }
      let(:item) { create(:attribute_item) }
      let(:post) { create(:post, project: project) }
      let(:attribute_value) { build(:attribute_value, :with_string, item: item, post: post) }

      context '重複した場合' do
        before do
          create(:attribute_value, :with_string, post: post, item: item)
        end

        it { is_expected.to be_truthy }
      end

      context 'postが重複していない場合' do
        before do
          create(:attribute_value, :with_string, item: item)
        end

        it { is_expected.to be_falsey }
      end

      context 'attribute_itemが重複していない場合' do
        before do
          create(:attribute_value, :with_string, post: post)
        end

        it { is_expected.to be_falsey }
      end

      context '両方が重複していない場合' do
        before do
          create(:attribute_value, :with_string)
        end

        it { is_expected.to be_falsey }
      end
    end

    describe 'is_visible' do
      let(:attribute_value) { build(:attribute_value, :with_string, is_visible: is_visible) }

      context 'nilの場合' do
        let(:is_visible) { nil }

        it { is_expected.to be_truthy }
      end
    end

    describe 'string' do
      describe 'string型' do
        let(:attribute_value) { build(:attribute_value, :with_string, string: string, required: required) }

        describe '必須' do
          let(:required) { :true }

          context 'nilの場合' do
            let(:string) { nil }

            it { is_expected.to be_truthy }
          end

          context '値がある場合' do
            let(:string) { 'a' * 140 }

            it { is_expected.to be_falsey }
          end

          context '空の場合' do
            let(:string) { '' }

            it { is_expected.to be_truthy }
          end

          context '上限以上' do
            let(:string) { 'a' * (length.string.max + 1) }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:string) { nil }

            it { is_expected.to be_truthy }
          end

          context '値がある場合' do
            let(:string) { 'a' * 140 }

            it { is_expected.to be_falsey }
          end

          context '空の場合' do
            let(:string) { '' }

            it { is_expected.to be_falsey }
          end

          context '上限以上' do
            let(:string) { 'a' * (length.string.max + 1) }

            it { is_expected.to be_truthy }
          end
        end
      end

      describe 'それ以外の型の場合' do
        let(:attribute_value) { build(:attribute_value, :with_integer, required: required, string: string) }

        describe '必須' do
          let(:required) { true }

          context 'nilの場合' do
            let(:string) { nil }

            it { is_expected.to be_falsey }
          end

          context '値がある場合' do
            let(:string) { 'a' * 140 }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:string) { nil }

            it { is_expected.to be_falsey }
          end

          context '値がある場合' do
            let(:string) { 'a' * 140 }

            it { is_expected.to be_truthy }
          end
        end
      end
    end

    describe 'integer' do
      describe 'integer型' do
        let(:attribute_value) { build(:attribute_value, :with_integer, integer: integer, required: required) }

        describe '必須' do
          let(:required) { :true }

          context 'nilの場合' do
            let(:integer) { nil }

            it { is_expected.to be_truthy }
          end

          context '値がある場合' do
            let(:integer) { 20 }

            it { is_expected.to be_falsey }
          end

          context '0の場合' do
            let(:integer) { 0 }

            it { is_expected.to be_falsey }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:integer) { nil }

            it { is_expected.to be_truthy }
          end

          context '値がある場合' do
            let(:integer) { 130 }

            it { is_expected.to be_falsey }
          end

          context '0の場合' do
            let(:integer) { 0 }

            it { is_expected.to be_falsey }
          end
        end
      end

      describe 'それ以外の型の場合' do
        let(:attribute_value) { build(:attribute_value, :with_text, required: required, integer: integer) }

        describe '必須' do
          let(:required) { true }

          context 'nilの場合' do
            let(:integer) { nil }

            it { is_expected.to be_falsey }
          end

          context '値がある場合' do
            let(:integer) { 30 }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:integer) { nil }

            it { is_expected.to be_falsey }
          end

          context '値がある場合' do
            let(:integer) { 30 }

            it { is_expected.to be_truthy }
          end
        end
      end
    end

    describe 'text' do
      describe 'text型' do
        let(:attribute_value) { build(:attribute_value, :with_text, text: text, required: required) }

        describe '必須' do
          let(:required) { :true }

          context 'nilの場合' do
            let(:text) { nil }

            it { is_expected.to be_truthy }
          end

          context '値がある場合' do
            let(:text) { 'a' * 140 }

            it { is_expected.to be_falsey }
          end

          context '空の場合' do
            let(:text) { '' }

            it { is_expected.to be_truthy }
          end

          context '上限以上' do
            let(:text) { 'a' * (length.text.max + 1) }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:text) { nil }

            it { is_expected.to be_truthy }
          end

          context '値がある場合' do
            let(:text) { 'a' * 140 }

            it { is_expected.to be_falsey }
          end

          context '空の場合' do
            let(:text) { '' }

            it { is_expected.to be_falsey }
          end

          context '上限以上' do
            let(:text) { 'a' * (length.text.max + 1) }

            it { is_expected.to be_truthy }
          end
        end
      end

      describe 'それ以外の型の場合' do
        let(:attribute_value) { build(:attribute_value, :with_integer, required: required, text: text) }

        describe '必須' do
          let(:required) { true }

          context 'nilの場合' do
            let(:text) { nil }

            it { is_expected.to be_falsey }
          end

          context '値がある場合' do
            let(:text) { 'a' * 140 }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:text) { nil }

            it { is_expected.to be_falsey }
          end

          context '値がある場合' do
            let(:text) { 'a' * 140 }

            it { is_expected.to be_truthy }
          end
        end
      end
    end

    describe 'markdown' do
      describe 'markdown型' do
        let(:attribute_value) { build(:attribute_value, :with_markdown, markdown: markdown, required: required) }

        describe '必須' do
          let(:required) { :true }

          context 'nilの場合' do
            let(:markdown) { nil }

            it { is_expected.to be_truthy }
          end

          context '値がある場合' do
            let(:markdown) { 'a' * 140 }

            it { is_expected.to be_falsey }
          end

          context '空の場合' do
            let(:markdown) { '' }

            it { is_expected.to be_truthy }
          end

          context '上限以上' do
            let(:markdown) { 'a' * (length.text.max + 1) }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:markdown) { nil }

            it { is_expected.to be_truthy }
          end

          context '値がある場合' do
            let(:markdown) { 'a' * 140 }

            it { is_expected.to be_falsey }
          end

          context '空の場合' do
            let(:markdown) { '' }

            it { is_expected.to be_falsey }
          end

          context '上限以上' do
            let(:markdown) { 'a' * (length.text.max + 1) }

            it { is_expected.to be_truthy }
          end
        end
      end

      describe 'それ以外の型の場合' do
        let(:attribute_value) { build(:attribute_value, :with_integer, required: required, markdown: markdown) }

        describe '必須' do
          let(:required) { true }

          context 'nilの場合' do
            let(:markdown) { nil }

            it { is_expected.to be_falsey }
          end

          context '値がある場合' do
            let(:markdown) { 'a' * 140 }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:markdown) { nil }

            it { is_expected.to be_falsey }
          end

          context '値がある場合' do
            let(:markdown) { 'a' * 140 }

            it { is_expected.to be_truthy }
          end
        end
      end
    end

    describe 'boolean' do
      describe 'boolean型' do
        let(:attribute_value) { build(:attribute_value, :with_boolean, boolean: boolean, required: required) }

        describe '必須' do
          let(:required) { :true }

          context 'nilの場合' do
            let(:boolean) { nil }

            it { is_expected.to be_truthy }
          end

          context '真の場合' do
            let(:boolean) { true }

            it { is_expected.to be_falsey }
          end

          context '偽の場合' do
            let(:boolean) { false }

            it { is_expected.to be_falsey }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:boolean) { nil }

            it { is_expected.to be_truthy }
          end

          context '真の場合' do
            let(:boolean) { true }

            it { is_expected.to be_falsey }
          end

          context '偽の場合' do
            let(:boolean) { false }

            it { is_expected.to be_falsey }
          end
        end
      end

      describe 'それ以外の型の場合' do
        let(:attribute_value) { build(:attribute_value, :with_text, required: required, boolean: boolean) }

        describe '必須' do
          let(:required) { true }

          context 'nilの場合' do
            let(:boolean) { nil }

            it { is_expected.to be_falsey }
          end

          context '真の場合' do
            let(:boolean) { true }

            it { is_expected.to be_truthy }
          end

          context '偽の場合' do
            let(:boolean) { false }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:boolean) { nil }

            it { is_expected.to be_falsey }
          end

          context '真の場合' do
            let(:boolean) { true }

            it { is_expected.to be_truthy }
          end

          context '偽の場合' do
            let(:boolean) { false }

            it { is_expected.to be_truthy }
          end
        end
      end
    end

    describe 'selected' do
      describe 'select型' do
        let(:attribute_value) { build(:attribute_value, :with_select, selected: selected, required: required) }

        describe '必須' do
          let(:required) { :true }

          context 'nilの場合' do
            let(:selected) { nil }

            it { is_expected.to be_truthy }
          end

          context '-1の場合' do
            let(:selected) { -1 }

            it { is_expected.to be_truthy }
          end

          context '0の場合' do
            let(:selected) { 0 }

            it { is_expected.to be_falsey }
          end

          context '1の場合' do
            let(:selected) { 1 }

            it { is_expected.to be_falsey }
          end

          context '存在しないvalueの場合' do
            let(:selected) { 99 }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:selected) { nil }

            it { is_expected.to be_truthy }
          end

          context '-1の場合' do
            let(:selected) { -1 }

            it { is_expected.to be_falsey }
          end

          context '0の場合' do
            let(:selected) { 0 }

            it { is_expected.to be_falsey }
          end

          context '1の場合' do
            let(:selected) { 1 }

            it { is_expected.to be_falsey }
          end

          context '存在しないvalueの場合' do
            let(:selected) { 99 }

            it { is_expected.to be_truthy }
          end
        end
      end

      describe 'それ以外の型の場合' do
        let(:attribute_value) { build(:attribute_value, :with_text, required: required, selected: selected) }

        describe '必須' do
          let(:required) { true }

          context 'nilの場合' do
            let(:selected) { nil }

            it { is_expected.to be_falsey }
          end

          context '0の場合' do
            let(:selected) { 0 }

            it { is_expected.to be_truthy }
          end

          context '1の場合' do
            let(:selected) { 1 }

            it { is_expected.to be_truthy }
          end
        end

        describe '必須でない' do
          let(:required) { false }

          context 'nilの場合' do
            let(:selected) { nil }

            it { is_expected.to be_falsey }
          end

          context '0の場合' do
            let(:selected) { 0 }

            it { is_expected.to be_truthy }
          end

          context '1の場合' do
            let(:selected) { 1 }

            it { is_expected.to be_truthy }
          end
        end
      end
    end
  end

  describe 'scope' do
    let!(:string_value) { create(:attribute_value, :with_string) }
    let!(:no_visible_string_value) { create(:attribute_value, :with_string, is_visible: false) }
    let!(:none_string_value) { create(:attribute_value, :with_string, string: '', required: false) }
    let!(:boolean_value) { create(:attribute_value, :with_boolean, boolean: false) }
    let!(:no_visible_boolean_value) { create(:attribute_value, :with_boolean, is_visible: false) }

    context '#visible' do
      subject { AttributeValue.visible }

      it { is_expected.to include string_value }
      it { is_expected.not_to include no_visible_string_value }
      it { is_expected.to include none_string_value }
      it { is_expected.to include boolean_value }
      it { is_expected.not_to include no_visible_boolean_value }
    end

    context '#has_value' do
      subject { AttributeValue.has_value }

      it { is_expected.to include string_value }
      it { is_expected.to include no_visible_string_value }
      it { is_expected.not_to include none_string_value }
      it { is_expected.to include boolean_value }
      it { is_expected.to include no_visible_boolean_value }
    end
  end

  describe '#value' do
    subject { attribute_value.value == value}

    context 'string' do
      let(:attribute_value) { create(:attribute_value, :with_string, string: value) }
      let(:value) { 'test_value' }

      it { is_expected.to be_truthy }
    end

    context 'integer' do
      let(:attribute_value) { create(:attribute_value, :with_integer, integer: value) }
      let(:value) { 100 }

      it { is_expected.to be_truthy }
    end

    context 'text' do
      let(:attribute_value) { create(:attribute_value, :with_text, text: value) }
      let(:value) { 'test_value' }

      it { is_expected.to be_truthy }
    end

    context 'markdown' do
      let(:attribute_value) { create(:attribute_value, :with_markdown, markdown: value) }
      let(:value) { 'test_value' }

      it { is_expected.to be_truthy }
    end

    context 'boolean' do
      let(:attribute_value) { create(:attribute_value, :with_boolean, boolean: value) }
      let(:value) { false }

      it { is_expected.to be_truthy }
    end

    context 'select' do
      let(:attribute_value) { create(:attribute_value, :with_select, selected: value) }
      let(:value) { 0 }

      it { is_expected.to be_truthy }
    end
  end

  describe '#value=' do
    subject { attribute_value.value == value}

    before {
      attribute_value.value = value
    }

    context 'string' do
      let(:attribute_value) { create(:attribute_value, :with_string) }
      let(:value) { 'test_value' }

      it { is_expected.to be_truthy }
    end

    context 'integer' do
      let(:attribute_value) { create(:attribute_value, :with_integer) }
      let(:value) { 199 }

      it { is_expected.to be_truthy }
    end

    context 'text' do
      let(:attribute_value) { create(:attribute_value, :with_text) }
      let(:value) { 'test_value' }

      it { is_expected.to be_truthy }
    end

    context 'markdown' do
      let(:attribute_value) { create(:attribute_value, :with_markdown) }
      let(:value) { 'test_value' }

      it { is_expected.to be_truthy }
    end

    context 'boolean' do
      let(:attribute_value) { create(:attribute_value, :with_boolean) }
      let(:value) { false }

      it { is_expected.to be_truthy }
    end

    context 'selected' do
      let(:attribute_value) { create(:attribute_value, :with_select) }
      let(:value) { 1 }

      it { is_expected.to be_truthy }
    end
  end
end
