class ChangeCommentUserIdAndContentToNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :comments, :user_id, true
    change_column_null :comments, :content, true
  end
end
