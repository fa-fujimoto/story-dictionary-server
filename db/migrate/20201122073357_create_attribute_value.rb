class CreateAttributeValue < ActiveRecord::Migration[6.0]
  def change
    create_table :attribute_values do |t|
      t.references :attribute_item, index: false, null: false
      t.references :post, index: false, null: false

      t.boolean :is_visible, index: true, default: false

      t.string :string
      t.integer :integer
      t.datetime :date
      t.text :text
      t.text :markdown
      t.boolean :boolean

      t.timestamps precision: 6
    end

    add_index :attribute_values, [:attribute_item_id, :post_id], unique: true
  end
end
