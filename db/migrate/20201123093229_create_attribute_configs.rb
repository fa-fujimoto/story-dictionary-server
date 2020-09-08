class CreateAttributeConfigs < ActiveRecord::Migration[6.0]
  def change
    create_table :attribute_configs do |t|
      t.references :project, index: false, null: false, foreign_key: true
      t.references :attribute_item, index: false, null: false, foreign_key: true
      t.boolean :is_visible, index: true, default: false

      t.timestamps precision: 6
    end

    add_index :attribute_configs, [:project_id, :attribute_item_id], unique: true
  end
end
