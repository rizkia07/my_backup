# -*r coding: utf-8 -*-
class Todo
  def initialize
    @t = Issue.where("parent_id is null").order('updated_at asc').first
    @tt = Issue.where(:parent_id => @t.id).order('updated_at asc').where(:parent_id => @t.id).first
  end

  def self.motion
    limit = 1*60*60 + 5+50 + 48 - 20
    todo = Todo.new
    10.times do |i|
      puts (10 - i).to_s
      sleep 1
    end
    i = 0
    while(i < limit) do 
      res = i.to_s + ' / ' + limit.to_s  + " : "
      if i%10 == 0
        res += todo.show
      else
        case i
        when 15
          res += "We are UFI !!!" 
        when 305
          res += "教育された〜い！" 
        when 494
          res += "推された〜い！" 
        when 745
          res += "あ〜りんのこと佐々木っていうな〜" 
        when 1024
          res += "マジでヤバーイ！" 
        when 1715
          res += "君、夢、友情！" 
        when 1835
          res += "働こう！" 
        when 2355
          res += "また来週〜" 
        when (limit - 60*5)
          res += "たった一度の今日という魔法☆" 
        end
      end
      puts res
      puts todo.detail if i%10 == 0
      i += 1
      sleep 1
    end
    puts "お疲れ様です！"
  end

  def add(subject)
    Issue.new({
      :subject => subject,
      :parent_id => nil
    }).save
  end

  def _add(subject)
    Issue.new({
      :subject => subject,
      :parent_id => @t.id
    }).save
  end

  def index
    Issue.where("parent_id is null").order('updated_at asc').map{|i| i.subject}
  end

  def detail
    Issue.where(:parent_id => @t.id).order('updated_at asc').map{|i| i.subject}
  end

  def n
    @t.update_attribute('updated_at', Time.now)
    @t = Issue.order('updated_at asc').where("parent_id is null").first
    show
  end

  def nn
    @tt.update_attribute('updated_at', Time.now)
    @tt = Issue.order('updated_at asc').where(:parent_id => @t.id).first
    detail
  end

  def show
    @t = Issue.where("parent_id is null").order('updated_at asc').first
    @t.subject
  end

  def _show
    @tt = Issue.where(:parent_id => @t.id).order('updated_at asc').where(:parent_id => @t.id).first
    @tt ? @tt.subject : "nothing!"
  end

end
