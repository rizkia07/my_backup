class FeedSubscription < ActiveRecord::Base
  attr_accessible :feed_site_id, :title, :uri, :user_id

  belongs_to :user
  belongs_to :feed_site
end
