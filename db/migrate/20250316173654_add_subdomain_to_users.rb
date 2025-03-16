class AddSubdomainToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :subdomain, :string, null: false, default: ''
  end
end
