class ChangeModelNameToIteration < ActiveRecord::Migration[7.1]
  def change
    rename_column :models, :name, :iteration
  end
end
