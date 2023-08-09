class RemoveColumFromPost < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :slug, :string
  end
  def change
    change_column_null :posts, :category, false
  end
end
