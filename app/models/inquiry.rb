class Inquiry < ActiveRecord::Base
  attr_accessible :issue_id, :status_id, :text, :user_id

  def self.create(data)
    Inquiry.new({
      :text => data[:text],
      :user_id => data[:user_id]
    }).save
  end
end
