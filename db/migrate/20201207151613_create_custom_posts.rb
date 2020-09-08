class CreateCustomPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_posts do |t|
      t.references :post, index: false, null: false, foreign_key: true, unique: true

      t.timestamps precision: 6
    end
  end
end
