class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :term_id, null: false, index: true
      t.string :name, null: false
      t.string :synopsis, default: ''
      t.text :body, default: ''
      t.integer :kind, null: false
      t.references :project, index: false, null: false, foreign_key: true

      t.timestamps precision: 6
    end

    add_index :categories, [:project_id, :term_id], unique: true
  end
end
