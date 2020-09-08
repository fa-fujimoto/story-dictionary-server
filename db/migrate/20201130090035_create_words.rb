class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.references :post, null: false, foreign_key: true, unique: true

      t.timestamps precision: 6
    end
  end
end
