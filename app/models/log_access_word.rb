class LogAccessWord < ActiveRecord::Base
  attr_accessible :branch_id, :user_id, :title_id
  belongs_to :user
  belongs_to :branch


  def self.plus(user_id=0, data)
    LogAccessWord.new({
      :user_id => user_id,
      :title_id => data[:title_id], 
      :branch_id => data[:branch_id],
    }).save
  end

end
