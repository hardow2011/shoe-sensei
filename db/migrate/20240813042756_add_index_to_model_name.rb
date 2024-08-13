class AddIndexToModelName < ActiveRecord::Migration[7.1]
  def change
    add_index :models, [:name, :collection_id], unique: true
  end
end
