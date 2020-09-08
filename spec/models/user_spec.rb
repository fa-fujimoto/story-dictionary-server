require 'rails_helper'

params_length = User::PARAMS_LENGTH

RSpec.describe User, type: :model do
  describe 'association' do
    it { is_expected.to have_many(:projects).inverse_of(:author) }
    it { is_expected.to have_many(:published_projects).conditions(is_published: true).class_name(:Project) }

    it { is_expected.to have_many(:follow_projects).conditions(approval: true).class_name(:ProjectFollower).dependent(:destroy) }
    it { is_expected.to have_many(:following_projects).through(:follow_projects).source(:project) }
    it { is_expected.to have_many(:published_following_projects).conditions(is_published: true).through(:follow_projects).source(:project) }

    it { is_expected.to have_many(:follow_requests).conditions(approval: false).class_name(:ProjectFollower).dependent(:destroy) }
    it { is_expected.to have_many(:requesting_projects).through(:follow_requests).source(:project) }
  end

  describe '通常パターンの場合' do
    let(:user) { build(:user) }

    example '不正にならないこと' do
      expect(user).to be_valid
    end
  end

  describe 'MAXパターンの場合' do
    let(:user) { build(:user_max) }

    example '不正にならないこと' do
      expect(user).to be_valid
    end
  end

  describe 'MINパターンの場合' do
    let(:user) { build(:user_min) }

    example '不正にならないこと' do
      expect(user).to be_valid
    end
  end

  describe 'name' do
    let(:user) { build(:user, name: name) }

    context '値が存在しない場合' do
      let(:name) { nil }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context '全角文字が含まれている場合' do
      let(:name) { 'ユーザーネーム' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context '区切り文字以外の記号が含まれている場合' do
      let(:name) { 'user@name' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context "#{params_length.name.min - 1}文字以下の場合" do
      let(:name) { 'a' * (params_length.name.min - 1) }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context "#{params_length.name.max + 1}文字以上の場合" do
      let(:name) { 'u' * (params_length.name.max + 1) }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context '重複した場合' do
      let(:name) { 'username' }

      example '不正になること' do
        create(:user, name: name)
        expect(user).not_to be_valid
      end
    end
  end

  describe 'Password' do
    let(:user) { build(:user, password: password, password_confirmation: password_confirmation) }
    let(:password_confirmation) { password }

    context '値が存在しない場合' do
      let(:password) { nil }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context '確認と値が一致しない場合' do
      let(:password) { 'Password@1' }
      let(:password_confirmation) { 'Password@2' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context "#{params_length.password.min - 1}文字以下の場合" do
      let(:password) { 'a' * (params_length.password.min - 3 - 1) + '@1A' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end


    context "#{params_length.password.max + 1}文字以上の場合" do
      let(:password) { 'a' * (params_length.password.max - 3 + 1) + '@1A' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context '大文字を含まない場合' do
      let(:password) { 'password@1111' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context '小文字を含まない場合' do
      let(:password) { 'PASSWORD@1111' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context '記号を含まない場合' do
      let(:password) { 'Passworda1111' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context '数字を含まない場合' do
      let(:password) { 'Password@aaaa' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end
  end

  describe 'email' do
    let(:user) { build(:user, email: email) }

    context '値が存在しない場合' do
      let(:email) { nil }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context 'メールの形式でない場合' do
      let(:email) { 'test@test' }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end

    context '値が重複した場合' do
      let(:email) { 'test@test.com' }

      example '不正になること' do
        create(:user, email: email)
        expect(user).not_to be_valid
      end
    end
  end

  describe 'nickname' do
    let(:user) { build(:user, nickname: nickname) }

    context "#{params_length.nickname.max + 1}文字以上の場合" do
      let(:nickname) { 'a' * (params_length.nickname.max + 1) }

      example '不正になること' do
        expect(user).not_to be_valid
      end
    end
  end
end
