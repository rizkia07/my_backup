class FeedSite < ActiveRecord::Base
  attr_accessible :title, :uri

  has_many :feed_subscriptions
  has_many :users, :through => :feed_subscriptions

  has_many :feed_entries

end
