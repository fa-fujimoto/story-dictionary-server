class ProjectFollower < ApplicationRecord
  before_save :auto_approve_if_published

  enum permission: { view: 0, edit: 1, admin: 2 }, _prefix: true
  enum approval: { approved: true, unapproved: false }

  belongs_to :user, inverse_of: :follow_projects
  belongs_to :project, inverse_of: :followed_users

  validates :project_id, uniqueness: { scope: :user_id }
  validates :approval, inclusion: { in: ProjectFollower.approvals.keys }
  validate :check_project_followable, on: :create

  scope :requesting, -> { where(approval: :unapproved) }

  def followed_permission
    if approved?
      permission
    else
      'requesting'
    end
  end

  private
  def auto_approve_if_published
    if project && project.published? && unapproved?
      self.approval = :approved
    end
  end

  def check_project_followable
    if project && !project.followable?(user)
      errors.add(:user_id, :invalid)
    end
  end
end
