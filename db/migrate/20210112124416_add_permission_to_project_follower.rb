class AddPermissionToProjectFollower < ActiveRecord::Migration[6.0]
  def change
    add_column :project_followers, :permission, :integer, index: true, default: 0
    remove_column :project_followers, :editable
  end
end
