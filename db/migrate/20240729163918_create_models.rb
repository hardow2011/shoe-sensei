class CreateModels < ActiveRecord::Migration[7.1]
  def change
    create_table :models do |t|
      t.string :full_name, null: false
      t.float :weight, null: false
      t.integer :heel_to_toe_drop, null: false
      t.integer :order, null: false
      t.boolean :apma_accepted, null: false
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
