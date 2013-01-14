# coding: UTF-8

class Notification < ActiveRecord::Base
  attr_accessible :body, :lang_id, :user_id, :title, :branch_id
  validates :user_id, :lang_id, :body, :title, :branch_id, presence: true
  validates :user_id, :lang_id, :branch_id, numericality: {greater_than: 0}
  #validates :user_id, uniqueness: true
  validates :user_id, :inclusion => { :in => User.find(:all).map(&:id)}
  validates :branch_id, :inclusion => { :in => Branch.find(:all).map(&:id)}
  validates :lang_id, :inclusion => { :in => [1, 2]}
  belongs_to :user

  def push_nofify
    if Title.is_japanese?(self.body)
      alert = self.body[0..34] + "…"
    else
      alert = self.body[0..216] + "…"
    end

    n = APNS::Notification.new(self.user.device_token, :alert => alert, :sound => 'default')
    puts n.packaged_message.length
    APNS.send_notifications([n])
  end

end
