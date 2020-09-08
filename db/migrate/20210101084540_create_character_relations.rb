class CreateCharacterRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :character_relations do |t|
      t.references :from, index: false, null: false, foreign_key: { to_table: :characters }
      t.references :to, index: false, null: false, foreign_key: { to_table: :characters }
      t.string :description
      t.text :detail
      t.string :name

      t.timestamps precision: 6
    end

    add_index :character_relations, [:from_id, :to_id], unique: true
  end
end
