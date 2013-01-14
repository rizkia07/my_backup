class Photo < ActiveRecord::Base
  attr_accessible :flickr_id, :info, :page, :query, :realname, :url_q, :username
end
