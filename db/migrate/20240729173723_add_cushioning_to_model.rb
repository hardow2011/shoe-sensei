class AddCushioningToModel < ActiveRecord::Migration[7.1]
  def change
    add_column :models, :cushioning, :integer, null: false
  end
end
