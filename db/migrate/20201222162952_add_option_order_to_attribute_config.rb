class AddOptionOrderToAttributeConfig < ActiveRecord::Migration[6.0]
  def change
    add_column :attribute_configs, :option_order, :integer
  end
end
