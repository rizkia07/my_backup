class LogUserMerge < ActiveRecord::Base
  attr_accessible :new_user_id, :old_user_id

  def merge
    User.merge(
      self.old_user_id, #96
      self.new_user_id #43
    )
  end
end
