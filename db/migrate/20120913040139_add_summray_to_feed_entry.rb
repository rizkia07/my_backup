class AddSummrayToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :summary, :text
  end
end
