class Tweet < ActiveRecord::Base
  attr_accessible :body, :body_escaped, :in_reply_to_status_id, :is_word, :point, :twitter_id, :twitter_word_id
end
