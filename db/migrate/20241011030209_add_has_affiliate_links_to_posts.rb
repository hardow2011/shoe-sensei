class AddHasAffiliateLinksToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :has_affiliate_links, :boolean, default: false
  end
end
