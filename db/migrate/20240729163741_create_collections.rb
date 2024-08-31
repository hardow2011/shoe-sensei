class CreateCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :collections do |t|
      t.string :name, null: false
      t.string :overview_en, null: false
      t.string :overview_es, null: false
      t.string :handle, null: false
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
