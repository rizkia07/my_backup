class AddTwitterIdToTitleTweet < ActiveRecord::Migration
  def change
    add_column :title_tweets, :twitter_id, :integer
  end
end
