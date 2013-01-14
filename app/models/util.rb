class Util
  def self.do_cron_by_sec(sec)
    while(true) do 
      puts "start"
      QueueBranch.do_cron
      QueueLeaf.do_cron
      QueueTitle.do_cron
      puts "end"
      sleep(sec)
    end
  end

  def self.analytics(date_str=nil)
    date_str = Date.today.to_s if !date_str
    next_str = ("#{date_str}".to_date - 1.day).to_s
    cond = "created_at < '#{date_str} 00:00:00' and created_at >= '#{next_str} 00:00:00'"
    users = User.where(cond).count
    pv = LogAccess.where(cond).count
    uu = LogAccess.select("distinct user_id").where(cond).count
    puts "new_users: #{users}, pv: #{pv}, uu:#{uu}"
  end
end
