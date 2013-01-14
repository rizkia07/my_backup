# -*r coding: utf-8 -*-
class RecentBranch
  def self.recent_contents(user)
    res = []
    Branch.where(
      "id > 100" 
    ).where(
    :lang_id => user.lang_id,
    :is_ng => false
    ).order('content_at desc').limit(20).each do |branch|

    res.push(
      {
        :branch_id => branch.id,
        :title => branch.title.name,
        :leaf_num => branch.leaf_num,
        :fav_num => branch.fav_num
      }) if !branch.title.url?
    end
    res
  end

  def self.recent_betters(user)
    branch_ids = user.branch_ids if !user.nil?
    if user.nil? || branch_ids.blank?
      res = nil
    else
      res = []
      Branch.where(
        branch_ids.blank? ? nil : "id in (#{branch_ids.join(',')})"
      ).where(
        "id > 100" 
      ).where(
        "better_id is not null" 
      ).where(
      :lang_id => user.lang_id,
      :is_ng => false
      ).order('parent_num asc').limit(5).each do |branch|
        res.push(
          {
            :branch_id => branch.id,
            :parent_id => branch.parent_id,
            :better_parent_id => branch.better.parent_id,
            :title => branch.title.name,
            :parent_title => branch.parent.text_breadcrumbs,
            :better_parent_title => branch.better.parent.text_breadcrumbs,
            :leaf_num => branch.leaf_num,
            :fav_num => branch.fav_num
          }) if !branch.title.url?
      end
    end
    res
  end

  def self.territory(user)
    branch_ids = user.branch_ids if !user.nil?

    if user.nil? || branch_ids.blank?
      res = nil
    else
      res = []
      Branch.where(
        branch_ids.blank? ? nil : "id in (#{branch_ids.join(',')})"
      ).where(
        "id > 100" 
      ).where(
      :lang_id => user.lang_id,
      :is_ng => false
      ).order('updated_at desc').limit(20).each do |branch|
      res.push(
        {
          :branch_id => branch.id,
          :title => branch.title.name,
          :leaf_num => branch.leaf_num,
          :fav_num => branch.fav_num
        }) if !branch.title.url?
      end
    end
    res
  end

  def self.territory_out(user)
    branch_ids = (user.nil? ? [] : user.branch_ids)
    res = []
    Branch.where(
      branch_ids.blank? ? nil : "id not in (#{branch_ids.join(',')})"
    ).where(
      "id > 100"
    ).where(
      :lang_id => user.lang_id,
      :is_ng => false
    ).order('updated_at desc').limit(20).each do |branch|
      res.push({
        :branch_id => branch.id,
        :title => branch.title.name,
        :leaf_num => branch.leaf_num,
        :fav_num => branch.fav_num
      }) if !branch.title.url?
    end
    res
  end
end
