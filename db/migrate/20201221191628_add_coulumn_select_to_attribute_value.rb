class AddCoulumnSelectToAttributeValue < ActiveRecord::Migration[6.0]
  def change
    add_column :attribute_values, :selected, :integer
  end
end
