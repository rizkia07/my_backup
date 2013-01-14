class AddPublishedAtToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :published_at, :datetime
  end
end
