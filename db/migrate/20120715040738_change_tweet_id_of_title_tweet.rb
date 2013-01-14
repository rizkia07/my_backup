class ChangeTweetIdOfTitleTweet < ActiveRecord::Migration
  def change
    change_column :title_tweets, :tweet_id, :bigint, {:limit => 20}
  end
end
