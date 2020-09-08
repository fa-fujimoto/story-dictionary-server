class ChangeColumnToPost < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :status, :integer, index: true, null: false
    add_column :posts, :disclosure_range, :integer
    add_index :posts, :disclosure_range
  end
end
