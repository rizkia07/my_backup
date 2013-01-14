class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :body
      t.integer :twitter_id
      t.integer :point
      t.integer :twitter_word_id
      t.text :body_escaped
      t.boolean :is_word
      t.integer :in_reply_to_status_id

      t.timestamps
    end
  end
end
