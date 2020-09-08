class CreateGroupRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :group_relations do |t|
      t.references :from, index: false, null: false, foreign_key: { to_table: :groups }
      t.references :to, index: false, null: false, foreign_key: { to_table: :groups }
      t.string :description
      t.text :detail

      t.timestamps precision: 6
    end

    add_index :group_relations, [:from_id, :to_id], unique: true
  end
end
