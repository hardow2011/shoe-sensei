class AddRetiredToModels < ActiveRecord::Migration[7.1]
  def change
    add_column :models, :retired, :boolean, default: false
  end
end
