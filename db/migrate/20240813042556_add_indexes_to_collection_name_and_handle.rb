class AddIndexesToCollectionNameAndHandle < ActiveRecord::Migration[7.1]
  def change
    add_index :collections, [:name, :brand_id], unique: true
    add_index :collections, [:handle, :brand_id], unique: true
    #Ex:- add_index("admin_users", "username")
  end
end
