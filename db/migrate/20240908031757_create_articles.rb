class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title_en, null: false
      t.string :title_es, null: false
      t.string :handle, null: false, index: { unique: true }
      t.boolean :published, null: false
      t.string :tags, array: true, default: [], null: false

      t.timestamps
    end
  end
end
