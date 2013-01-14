class Theme < ActiveRecord::Base
  attr_accessible :branch_id, :date
  belongs_to :branch
end
