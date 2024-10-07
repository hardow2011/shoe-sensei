class AddPublishedAtToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :published_at, :date, default: Date.current
  end
end
