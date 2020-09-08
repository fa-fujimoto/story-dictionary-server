class AddColumnCustomFolderToPost < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :custom_folder, foreign_key: true
  end
end
