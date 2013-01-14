class CreateTitleTweets < ActiveRecord::Migration
  def change
    create_table :title_tweets do |t|
      t.integer :title_id
      t.integer :tweet_id
      t.integer :point, {:default => 0}

      t.timestamps
    end
    change_column :tweets, :point, :integer, {:default => 0}
  end
end
