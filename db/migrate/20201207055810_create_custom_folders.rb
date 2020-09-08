class CreateCustomFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_folders do |t|
      t.string :term_id, null: false
      t.string :name, null: false
      t.boolean :is_visible, default: false
      t.references :project, index: false, null: false, foreign_key: true

      t.timestamps precision: 6
    end

    add_index :custom_folders, [:term_id, :project_id], unique: true
  end
end
