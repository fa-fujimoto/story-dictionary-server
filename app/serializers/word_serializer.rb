class WordSerializer < ApplicationSerializer
  attributes :term_id, :name, :kana, :synopsis, :status
  attribute :is_replyable, if: :detail?
  attribute :is_comment_release_soon, if: :detail?

  has_many :attribute_values, key: :attr

  belongs_to :category
  belongs_to :author
  belongs_to :last_editor

  has_many :comments

  def attr
    object.attribute_values
  end

  def is_replyable
    object.replyable_for? current_user
  end

  def is_comment_release_soon
    object.comment_release_soon? current_user
  end

  def detail?
    instance_options[:detail]
  end

  class CategorySerializer < ApplicationSerializer
    attributes :term_id, :name
  end
end
