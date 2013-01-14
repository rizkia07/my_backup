class FeedEntry < ActiveRecord::Base
  attr_accessible :feed_site_id, :title, :uri

  belongs_to :feed_site

  has_many :feed_reads
  has_many :users, :through => :feed_reads

end
