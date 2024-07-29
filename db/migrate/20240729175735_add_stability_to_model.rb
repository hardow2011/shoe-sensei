class AddStabilityToModel < ActiveRecord::Migration[7.1]
  def change
    add_column :models, :stability, :boolean, null: false
  end
end
