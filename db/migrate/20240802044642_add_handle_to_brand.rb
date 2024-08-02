class AddHandleToBrand < ActiveRecord::Migration[7.1]
  def change
    add_column :brands, :handle, :string, null: false
  end
end
