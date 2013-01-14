# -*r coding: utf-8 -*-
class Tutorial < ActiveRecord::Base
  attr_accessible :key, :previous_id, :title, :val, :branch_id, :branch_id_ja

  def self.get(user_id)
    res = TutorialUser.get(user_id)
    res ? res.map{|i| i.tutorial} : nil
  end

  def self.updt(user_id)
    TutorialUser.get(user_id).each do |tutorial_user|
      tutorial_user.updt 
    end
  end
end
