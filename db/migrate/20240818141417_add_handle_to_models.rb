class AddHandleToModels < ActiveRecord::Migration[7.1]
  def change
    add_column :models, :handle, :string, null: false
  end
end
