class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :handle, null: false, index: { unique: true }
      t.string :overview, null: false

      t.timestamps
    end
  end
end
