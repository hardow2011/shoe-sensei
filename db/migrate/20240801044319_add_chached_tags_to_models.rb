class AddChachedTagsToModels < ActiveRecord::Migration[7.1]
  def change
    add_column :models, :cached_tags, :json
  end
end
