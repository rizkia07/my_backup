class QueueTitle < ActiveRecord::Base
  attr_accessible :is_done, :title_id
  belongs_to :title

  def self.add(title_id)
    QueueTitle.find_or_create_by_is_done_and_title_id(
      false,
      title_id
    )
  end

  def self.do_cron
    cond = {
      :is_done => false
    }
    QueueTitle.where(cond).each do |i|
      title = Title.find(i.title_id)
      title.updt_parents
      title.updt_url if title.url?
      title.set_flickr_photo
      i.is_done = true
      i.save
    end
  end
end
