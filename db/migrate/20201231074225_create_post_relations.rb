class CreatePostRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :post_relations do |t|
      t.references :from, index: false, null: false, foreign_key: { to_table: :posts }
      t.references :to, index: false, null: false, foreign_key: { to_table: :posts }
      t.string :description
      t.text :detail

      t.timestamps precision: 6
    end

    add_index :post_relations, [:from_id, :to_id], unique: true
  end
end
