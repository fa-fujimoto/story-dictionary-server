class CreateAttributeOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :attribute_options do |t|
      t.string :name, null: false
      t.integer :value, null: false
      t.references :attribute_item, index: false, null: false, foreign_key: true

      t.timestamps precision: 6
    end

    add_index :attribute_options, [:attribute_item_id, :value], unique: true
  end
end
