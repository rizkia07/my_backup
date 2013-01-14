class CreateFeedSites < ActiveRecord::Migration
  def change
    create_table :feed_sites do |t|
      t.text :title
      t.text :uri

      t.timestamps
    end
  end
end
