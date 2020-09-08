class CreateProjectFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_followers do |t|
      t.references :user, index: false, null: false, foreign_key: true
      t.references :project, index: false, null: false, foreign_key: true
      t.boolean :editable, default: false

      t.timestamps
    end

    add_index :project_followers, [:user_id, :project_id], unique: true
  end
end
