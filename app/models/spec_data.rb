class SpecData
  def self.branch(name, parent_id=nil)
    title = Title.find_by_name(name)
    if !parent_id
      Branch.find_by_title_id(title.id)
    else
      Branch.find_by_title_id_and_parent_id(title.id, parent_id)
    end
  end

  def self.user(name)
    User.find_by_name(name)
  end
end

