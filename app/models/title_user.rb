class TitleUser < ActiveRecord::Base
  attr_accessible :canceled_at, :checked_at, :point, :title_id, :user_id, :hot_at
  belongs_to :title  
  belongs_to :user

  def self.updt_by_sec(sec)
    while(true)
      TitleUser.updt
      sleep(sec)
    end
  end

  def self.updt
    User.where('twitter_id is not null').each do |user|
      TitleTweet.select(
        'distinct title_id'
      ).where(
        :twitter_id => user.twitter_id 
      ).each do |i|
        title_user = TitleUser.find_or_create_by_user_id_and_title_id(
          user.id,
          i.title_id
        )
        branch_ids = Branch.where(
          :title_id => i.title_id,
          :is_ng => false
        ).map{|i|
          i.id 
        }

        if !branch_ids.blank?
          leafs = Leaf.where(
            :branch_id => branch_ids,
            :user_id => user.id,
            :is_disabled => false
          )
          if leafs
            title_user.checked_at = Time.now
            title_user.save
          end
        end
      end
    end
  end

  def self.updt_by_leaf
    Leaf.where(
      :is_disabled => false
    ).each do |leaf|
      TitleUser.find_or_create_by_user_id_and_title_id(
        leaf.user_id,
        leaf.branch.title_id
      ).update_attribute("checked_at", Time.now) if leaf.branch && leaf.branch.title_id
    end
  end
  
  def self.get_checks(user_id)
    data = TitleUser.where(:user_id => user_id).where('checked_at is null').order("hot_at asc").limit(25)
    res = data.map{|i| i.title.name}
    res
  end

  def self.do_update(user_id)
    data = TitleUser.where(:user_id => user_id).where('checked_at is null').order("hot_at asc").limit(25)
    data.each do |i|
      i.hot_at = Time.now
      i.save
    end
  end
end
