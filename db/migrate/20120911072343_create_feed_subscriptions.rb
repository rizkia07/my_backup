class CreateFeedSubscriptions < ActiveRecord::Migration
  def change
    create_table :feed_subscriptions do |t|
      t.integer :user_id
      t.integer :feed_site_id
      t.text :title
      t.text :uri

      t.timestamps
    end
  end
end
