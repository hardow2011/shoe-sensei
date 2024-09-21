class AddContentToPost < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :content_en, :string, null: false
    add_column :posts, :content_es, :string, null: false
  end
end
