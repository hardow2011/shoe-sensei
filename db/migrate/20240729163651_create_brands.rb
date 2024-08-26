class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :handle, null: false, index: { unique: true }
      t.string :overview_en, null: false
      t.string :overview_es, null: false

      t.timestamps
    end
  end
end
