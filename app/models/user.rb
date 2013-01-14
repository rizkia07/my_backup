# coding: utf-8

class User < ActiveRecord::Base
  devise :omniauthable
  
  attr_accessible :name, :twitter_id, :app_token, :org_id, :twitter_token, :twitter_secret
  
  validates :name, :twitter_id, presence: true
  validates :name, :twitter_id, uniqueness: true
  validates :twitter_id, numericality: {greater_than: 0}
  
  has_many :feed_subscriptions
  has_many :feed_sites, :through => :feed_subscriptions

  has_many :feed_reads
  has_many :feed_entries, :through => :feed_reads

  has_many :notifications
  has_many :log_access_words
  has_many :bookmarks

  after_create :thankyou
  
  def branch_ids
    Leaf.where(
      :user_id => self.id,
      :is_disabled => false
    ).map{|leaf|
      leaf.branch_id
    }
  end

  def update_via_twitter_auth(data)
    self.twitter_id = data[:uid]
    self.name = data[:info][:name]
    #self.img = data[:info][:image]

    self.twitter_token = data['credentials']['token']
    self.twitter_secret = data['credentials']['secret']
    self.save!
    self
  end

  def self.get_via_twitter_auth(data)
    user = User.find_or_create_by_twitter_id(data[:uid])
    user.name = data[:info][:name]
    #user.img = data[:info][:image]

    user.twitter_token = data['credentials']['token']
    user.twitter_secret = data['credentials']['secret']

    user.save
    user
  end
  
  def self.find_for_twitter_oauth(omniauth)
    user = User.find_by_twitter_id(omniauth['uid'])
    unless user
      user = User.new( :name => omniauth['info']['name'],
                       :twitter_id => omniauth['uid'],
                       :twitter_token=>omniauth["credentials"]["token"],
                       :twitter_secret=>omniauth["credentials"]["secret"])
      user.save!                          
    else
      user.update_attributes(:twitter_token => omniauth.credentials.token, :twitter_secret => omniauth.credentials.secret)
    end
    user
  end
  
  def self.add
    user = User.new
    user.save
    user.set_app_token
    user
  end

  def set_app_token
    self.app_token = Digest::SHA256.hexdigest(
      self.id.to_s + UUIDTools::UUID.random_create.to_s
    )
    self.save
  end

  def self.merge(old_user_id, new_user_id)
    Leaf.where(
      :user_id => old_user_id,
      :is_disabled => false
    ).each do |leaf_old|
      leaf = Leaf.find_or_create_by_user_id_and_branch_id_and_is_disabled(
        new_user_id,
        leaf_old.branch_id,
        false
      )
      leaf.updt_content(leaf_old.content.text) if leaf_old.content
      leaf.save
      leaf_old.is_disabled = true
      leaf_old.save
    end
    LogUserMerge.find_or_create_by_old_user_id_and_new_user_id(
      old_user_id,
      new_user_id
    )
  end

  def premium_expire_days
    return 0 if self.premium_expired_at.nil?
    interval = self.premium_expired_at - Time.now
    days = (interval / 60 / 60 / 24).ceil
    return days
  end

  def merge_premium(old_user)
    if self.premium_expired_at.nil?
      self.premium_expired_at = old_user.premium_expired_at
    elsif !old_user.premium_expired_at.nil?
      self.premium_expired_at += old_user.premium_expire_days.days
    end
    self.save
    old_user.premium_expired_at = nil
    old_user.save
  end

  def merge_device(old_user)
    self.device_token = old_user.device_token
    self.save
    old_user.device_token = nil
    old_user.save
  end

  def count_leaf
    leafs = Leaf.where(
      :is_disabled => false,
      :user_id => self.id
    ).count
  end

  def count_branch
    branches = Branch.where(
      :user_id => self.id
    ).count
  end

  def updt_tutorial
    Tutorial.updt(self.id)
  end

  def tutorials
    Tutorial.get(self.id)
  end
  
  def updt_lang_id(lang_id)
    self.update_attribute('lang_id', lang_id.to_i)
  end

  def recent_contents
    RecentBranch.recent_contents(self)
  end

  def recent_betters
    RecentBranch.recent_betters(self)
  end

  def territories
    RecentBranch.territory(self)
  end

  def territory_outs
    RecentBranch.territory_out(self)
  end

private 

  def thankyou
      ja = Notification.new
      #ja.branch_id = 0
      ja.lang_id = 2
      ja.title = "バトンのご利用ありがとうございます"
      ja.body = "タイピングなしでいろんな知識を楽しめるバトン、調べ物に、暇潰しに、是非活用してください！"
      ja.user_id = self.id
      ja.save

      en = Notification.new
      #en.branch_id = 0
      en.lang_id = 1
      en.title = "Thank you for using our Baton app"
      en.body = "Enjoy exploring knowledge with no-typing!"
      en.user_id = self.id
      en.save
  end

end
