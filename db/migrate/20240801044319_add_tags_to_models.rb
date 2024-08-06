class AddTagsToModels < ActiveRecord::Migration[7.1]
  def change
    add_column :models, :tags, :jsonb, null: false, default: {}
  end
end
