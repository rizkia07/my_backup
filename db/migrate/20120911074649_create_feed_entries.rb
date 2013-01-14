class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.integer :feed_site_id
      t.text :uri
      t.text :title

      t.timestamps
    end
  end
end
