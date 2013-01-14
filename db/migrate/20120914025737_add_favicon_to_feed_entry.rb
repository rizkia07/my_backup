class AddFaviconToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :favicon, :text
  end
end
