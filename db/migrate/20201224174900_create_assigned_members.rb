class CreateAssignedMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :assigned_members do |t|
      t.references :group, index: false, null: false, foreign_key: true
      t.references :character, index: false, null: false, foreign_key: true
      t.string :description
      t.text :detail

      t.timestamps precision: 6
    end

    add_index :assigned_members, [:group_id, :character_id], unique: true
  end
end
