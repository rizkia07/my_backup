class Report < ActiveRecord::Base
  attr_accessible :branch_id, :user_id
  def self.create(report)
    Report.find_or_create_by_branch_id_and_user_id(
      report[:branch_id],
      report[:user_id]
    )
    leaf = Leaf.find_by_branch_id_and_user_id(
      report[:branch_id],
      report[:user_id]
    )
    leaf.update_attribute('is_disabled', true) if leaf
    branch = Branch.find(report[:branch_id].to_i)
    branch.update_attribute('is_ng', true)
    TitleParent.add_is_ng(branch)
  end

  def self.main(model, user_id=nil)
    res = {
      :today => "#{self.get_count(model, 'today', user_id).to_currency} / #{self.get_count(model, 'today').to_currency}",
      :yesterday => "#{self.get_count(model, 'yesterday', user_id).to_currency} / #{self.get_count(model, 'yesterday').to_currency}",
      :thismonth => "#{self.get_count(model, 'thismonth', user_id).to_currency} / #{self.get_count(model, 'thismonth').to_currency}",
      :thisyear => "#{self.get_count(model, 'thisyear', user_id).to_currency} / #{self.get_count(model, 'thisyear').to_currency}",
      :pre_today => "#{self.get_predict(model, 'today', user_id).to_currency} / #{self.get_count(model, 'today').to_currency}",
      :pre_yesterday => "#{self.get_count(model, 'yesterday', user_id).to_currency} / #{self.get_count(model, 'yesterday').to_currency}",
      :pre_thismonth => "#{self.get_predict(model, 'thismonth', user_id).to_currency} / #{self.get_count(model, 'thismonth').to_currency}",
      :pre_thisyear => "#{self.get_predict(model, 'thisyear', user_id).to_currency} / #{self.get_count(model, 'thisyear').to_currency}",
    }
  end

  def self.get_predict(model, key=nil, user_id=nil)
    past = self.get_count(model, "past1hour", user_id)
    yesterday = self.get_count(model, "yesterday", user_id)
    yesterday0_9 = self.get_count(model, "yesterday0_9", user_id)
    if yesterday == 0
      yesterday = past*24 #TODO
      yesterday0_9 = past*10 #TODO
    end
    now = Time.now
    today = now - (now.hour*60*60 + now.min*60 + now.sec)
    next_newmonth = DateTime.new(now.year, now.month+1, 1)
    next_newmonth = DateTime.new(now.year, 1, 1) if now.month > 12
    next_newyear = DateTime.new(now.year+1, 1, 1)
    
    remain_month = ((next_newmonth.to_i - today.to_i)/(24*60*60)).to_i - 1 
    remain_year = ((next_newyear.to_i - today.to_i)/(24*60*60)).to_i - 1
    case key
    when "today"
      res = self.get_count(model, 'today', user_id) + past*(24-now.hour)
    when "thismonth"
      res = self.get_count(model, 'thismonth', user_id) + past*(24-now.hour) 
      res += (now.hour < 10) ? yesterday*remain_month : (yesterday0_9 + past*14)*remain_month
    when "thisyear"
      res = self.get_count(model, 'thisyear', user_id) + past*(24-now.hour)
      res += (now.hour < 10) ? yesterday*remain_year : (yesterday0_9 + past*14)*remain_year
    end
    res
  end

  def self.get_count(model, key=nil, user_id=nil)
    cond = (model.to_s == "Branch" ? {:is_ng => false} : nil)
    cond_leaf_num = (model.to_s == "Branch" ? 'leaf_num > 0' : nil)
    now = Time.now
    today = now - (now.hour*60*60 + now.min*60 + now.sec)
    yesterday = today - (24*60*60)
    yesterday_10 = yesterday + (10*60*60)
    thismonth = today - (now.day*24*60*60)
    case key
    when "past1hour"
      term = ["created_at > ?", now-60*60]
    when "today"
      term = ["created_at > ?", today]
    when "thismonth"
      term = ["created_at > ?", thismonth]
    when "yesterday"
      term = ["created_at >  ? and created_at <  ?", yesterday, today]
    when "yesterday0_9"
      term = ["created_at >  ? and created_at <  ?", yesterday, yesterday_10]
    when "thisyear"
      term = nil #TODO (deadline is 2012-12-30)
    else
      term = nil
    end
    if model.to_s != "User"
      cond_user = (user_id ? {:user_id => user_id} : nil)
    elsif user_id
      user = User.find(user_id)
      cond_user = {:lang_id => user.lang_id}
    end
    model.where(
      cond_leaf_num
    ).where(
      cond
    ).where(
      cond_user
    ).where(
      term 
    ).count
  end

  def self.daily
    ReportMailer.sent.deliver
  end
end

class Integer
  def to_currency()
    self.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
  end
end


