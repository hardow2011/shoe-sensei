class AddHandleToBrand < ActiveRecord::Migration[7.1]
  def change
    add_column :brands, :handle, :string
  end
end
