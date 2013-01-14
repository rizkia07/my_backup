class FeedRead < ActiveRecord::Base
  attr_accessible :feed_entry_id, :is_read, :user_id

  belongs_to :user
  belongs_to :feed_entry

  def count_up
    self.view_count += 1
    if self.view_count > 3
      self.is_read = true
    end
    self.save
  end

end
