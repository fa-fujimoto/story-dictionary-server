class Comment < ApplicationRecord
  before_validation :status_auto_fix, on: :create

  enum status: { open: 0, requesting: 1, deleted: -1 }

  belongs_to :author, class_name: :User, foreign_key: :user_id
  belongs_to :post

  belongs_to :reply_to,
    class_name: :Comment,
    foreign_key: :comment_id,
    inverse_of: :replies,
    optional: true

  has_many :replies,
    class_name: :Comment,
    foreign_key: :comment_id,
    inverse_of: :reply_to,
    dependent: :destroy

  validates :body, presence: true, length: { in: 1..10000 }
  validates :status, inclusion: { in: Comment.statuses.keys }

  validate do
    if reply_to && !belongs_to_same_post_for?(reply_to)
      errors.add(:reply_to, :invalid)
    end
  end

  validate do
    if reply_to && !reply_to.replyable_for?(author)
      errors.add(:reply_to, 'not replyable author')
    end
  end

  def belongs_to_same_post_for?(item)
    item.post_id == post_id
  end

  def replyable_for?(user)
    post.replyable_for?(user) && open?
  end

  def destroy(with_children_delete = false)
    if with_children_delete || replies.empty?
      super()
    else
      deleted!
    end
  end

  private
  def status_auto_fix
    comment_release_soon = post && post.comment_release_soon?(author)

    if comment_release_soon && !open?
      self.status = :open
    elsif !comment_release_soon && !requesting?
      self.status = :requesting
    end
  end
end
