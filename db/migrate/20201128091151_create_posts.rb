class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :name, index: true, null: false
      t.string :term_id, null: false
      t.string :kana, null: false, index: true
      t.string :synopsis, default: ''
      t.string :status, index: true, null: false, default: 'draft'
      t.references :project, index: false, null: false, foreign_key: true
      t.references :category, index: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :last_editor, null: false, foreign_key: { to_table: :users }

      t.timestamps precision: 6
    end

    add_index :posts, [:project_id, :term_id], unique: true
    add_index :posts, [:category_id, :term_id], unique: true
  end
end
