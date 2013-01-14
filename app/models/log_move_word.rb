class LogMoveWord < ActiveRecord::Base
  attr_accessible :branch_id, :new_branch_id, :user_id

  def self.add(branch_id, new_branch_id, user_id)
    LogMoveWord.new({
      :branch_id => branch_id,
      :new_branch_id => new_branch_id,
      :user_id => user_id
    }).save
  end
end
