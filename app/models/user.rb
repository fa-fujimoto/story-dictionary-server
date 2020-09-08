# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :projects, inverse_of: 'author'
  has_many :published_projects, -> { published }, class_name: :Project

  has_many :posts, inverse_of: 'author'
  has_many :edited_posts, class_name: 'Post', inverse_of: 'last_editor'

  has_many :follow_projects, -> { approved }, class_name: :ProjectFollower, dependent: :destroy
  has_many :following_projects, through: :follow_projects, source: :project
  has_many :published_following_projects, -> { published }, through: :follow_projects, source: :project

  has_many :follow_requests, -> { unapproved }, class_name: :ProjectFollower, dependent: :destroy
  has_many :requesting_projects, through: :follow_requests, source: :project

  PARAMS_LENGTH = Settings.model.params_length.user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true,
    format: { with: /\A[\w]+\z/ },
    length: {
      minimum: PARAMS_LENGTH.name.min,
      maximum: PARAMS_LENGTH.name.max
    },
    uniqueness: true
  validates :email,
    uniqueness: true
  validates :nickname,
    length: {
      maximum: PARAMS_LENGTH.nickname.max,
      allow_blank: true
    }
  validates :password, presence: { on: :create },
    length: {
      minimum: PARAMS_LENGTH.password.min,
      maximum: PARAMS_LENGTH.password.max,
      allow_blank: true
    }
  validate :password_complexity

  def to_param
    name
  end

  private
  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{#{PARAMS_LENGTH.password.min},#{PARAMS_LENGTH.password.max}}$/
    errors.add :password, "パスワードの強度が不足しています。パスワードの長さは#{PARAMS_LENGTH.password.min}文字以上とし、大文字と小文字と数字と特殊文字をそれぞれ1文字以上含める必要があります。"
  end
end
