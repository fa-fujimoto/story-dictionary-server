class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :term_id, null: false, unique: true, index: true
      t.string :name, null: false
      t.string :kana, null: false
      t.text :description, null: false, default: ''
      t.boolean :is_published, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps precision: 6
    end

    add_index :projects, [:user_id, :term_id], unique: true
  end
end
