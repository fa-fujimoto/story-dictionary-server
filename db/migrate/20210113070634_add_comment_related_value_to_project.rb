class AddCommentRelatedValueToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :commentable_status, :integer, default: 0
    add_column :projects, :comment_viewable, :integer, default: 0
    add_column :projects, :comment_publish, :integer, default: 0

    add_index :projects, :commentable_status
    add_index :projects, :comment_viewable
    add_index :projects, :comment_publish
  end
end
