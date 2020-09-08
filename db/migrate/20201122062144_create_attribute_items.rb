class CreateAttributeItems < ActiveRecord::Migration[6.0]
  def change
    create_table :attribute_items do |t|
      t.string :name, null: false
      t.boolean :required, null: false, default: false

      t.integer :post_type, index: true, default: 0
      t.integer :kind, index: true, default: 0
      t.boolean :default_item, index: true, default: false
      t.references :custom_folder

      t.timestamps precision: 6
    end
  end
end
