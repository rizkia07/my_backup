class QueueLeaf < ActiveRecord::Base
  attr_accessible :is_done, :leaf_id
  belongs_to :leaf

  def self.add(leaf_id)
    QueueLeaf.find_or_create_by_is_done_and_leaf_id(
      false,
      leaf_id
    )
  end

  def self.do_cron
    cond = {
      :is_done => false
    }
    QueueLeaf.where(cond).each do |i|
      checked_at = i.leaf.is_disabled ? nil : Time.now
      TitleUser.find_or_create_by_title_id_and_user_id(
        i.leaf.branch.title_id,
        i.leaf.user_id
      ).update_attribute('checked_at', checked_at)
      i.is_done = true
      i.save
      i.leaf.updt_parents
      i.leaf.branch.add_search_links()
      if i.leaf.branch.title.url?
        Feed.subscribe(i.leaf.user, i.leaf.branch.title.name)
      end
    end
  end

end
