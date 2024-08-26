class AddCompanyColorToBrand < ActiveRecord::Migration[7.1]
  def change
    add_column :brands, :company_color, :string, null: false, limit: 7
  end
end
