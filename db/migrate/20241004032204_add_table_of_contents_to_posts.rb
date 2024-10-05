class AddTableOfContentsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :table_of_contents_en, :jsonb, null: false, default: []
    add_column :posts, :table_of_contents_es, :jsonb, null: false, default: []
  end
end
