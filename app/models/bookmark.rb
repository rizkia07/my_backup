class Bookmark < ActiveRecord::Base
  attr_accessible :branch_id, :user_id

  belongs_to :user
  belongs_to :branch
end
