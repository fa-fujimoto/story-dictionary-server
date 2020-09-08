class AddColumnToProjectFollower < ActiveRecord::Migration[6.0]
  def change
    add_column :project_followers, :approval, :boolean, index: true, null: false
  end
end
