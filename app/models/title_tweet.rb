# -*r coding: utf-8 -*-
#require "MeCab" 

class String
  def mbstring?
    self.match(/^[a-zA-Z0-9_\.]*$/) ? true : false
  end


  def do_escape
    self.gsub(/https?:\/\/[a-zA-Z0-9\.\/\-]*/,'').gsub(/@[a-z0-9_]*/,'')
  end


end

class TitleTweet < ActiveRecord::Base
  attr_accessible :point, :title_id, :tweet_id, :twitter_id
  belongs_to :title
  belongs_to :tweet

  def self.updt
    Title.order('id desc').where(:is_ng => false).all.each do |t|
      next if t.name.size < 3 && t.name.mbstring?
      next if t.name.size < 2 && !t.name.mbstring?
      tweets = Tweet.where("body_escaped like '%#{t.name}%'")
      tweets.each do |tweet|
        tt = TitleTweet.find_or_create_by_title_id_and_twitter_id_and_tweet_id(t.id, tweet.twitter_id, tweet.id)
        tt.update_attribute('point', tweet.point)
      end
    end
  end
  
  def self.updt_by_mecab
    # http://l-w-i.net/t/mecab
    #m = MeCab::Tagger.new ("-O wakati")
    m = MeCab::Tagger.new
    User.where("twitter_id is not null").each do |user| 
      Tweet.where(:twitter_id => user.twitter_id).each do |tweet|
        tbody = tweet.body.do_escape
        next if !m.parse(tbody)
        m.parse(tbody).force_encoding('UTF-8').split("\n").each do |i|
          next if i == "EOS"
          t = i.split("\t")
          next if t[1].split(",")[0] != "名詞"
          mwd = t[0] 
          next if mwd.size < 3 && mwd.mbstring?
          next if mwd.size < 2 && !mwd.mbstring?
          title = Title.get(mwd)
          tt = TitleTweet.find_or_create_by_title_id_and_tweet_id_and_twitter_id(
            title.id,
            tweet.id,
            tweet.twitter_id
          )
          tt.update_attribute('point', tweet.point)
        end
      end
    end
  end
end
