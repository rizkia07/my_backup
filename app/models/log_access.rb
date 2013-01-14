class LogAccess < ActiveRecord::Base
  attr_accessible :actn, :ctrlr, :params, :user_id
  def self.plus(user_id=0, data)
    LogAccess.new({
      :user_id => user_id,
      :ctrlr => data[:controller], 
      :actn => data[:action],
      :params => data.inspect
    }).save
  end
end
