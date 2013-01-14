class AddViewCountToFeedRead < ActiveRecord::Migration
  def change
    add_column :feed_reads, :view_count, :integer, :default => 0
  end
end
