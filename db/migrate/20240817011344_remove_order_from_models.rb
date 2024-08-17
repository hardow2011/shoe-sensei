class RemoveOrderFromModels < ActiveRecord::Migration[7.1]
  def change
    remove_column :models, :order, :integer
  end
end
