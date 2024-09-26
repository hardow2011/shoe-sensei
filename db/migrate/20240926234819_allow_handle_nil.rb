class AllowHandleNil < ActiveRecord::Migration[7.1]
  def change
    change_column :posts, :handle, :string, null: true
  end
end
