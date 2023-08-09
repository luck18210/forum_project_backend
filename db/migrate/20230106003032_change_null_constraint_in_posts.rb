class ChangeNullConstraintInPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :content, false
    change_column_null :posts, :title, false
    change_column_null :posts, :author, false
    change_column_null :comments, :content, false
    change_column_null :comments, :author, false
  end
end
