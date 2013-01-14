def RecentBranch
  def self.territory(user, lang_id)
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
      :lang_id => lang_id,
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

  def self.territory_out(user, lang_id)
    branch_ids = (user.nil? ? [] : user.branch_ids)
    res = []
    Branch.where(
      branch_ids.blank? ? nil : "id not in (#{branch_ids.join(',')})"
    ).where(
      "id > 100"
    ).where(
      :lang_id => lang_id,
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


