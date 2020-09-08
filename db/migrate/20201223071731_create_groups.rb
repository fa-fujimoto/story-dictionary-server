class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.references :post, null: false, foreign_key: true, unique: true
      t.references :parent, foreign_key: { to_table: :groups }
      t.boolean :is_department, default: false

      t.timestamps precision: 6
    end
  end
end
