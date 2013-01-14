class Leaf < ActiveRecord::Base
  attr_accessible :branch_id, :content_id, :user_id, :is_disabled, :branch_parent_id
  belongs_to :branch
  belongs_to :content
  belongs_to :user

  def self.get(branch_id, user_id)
    where = {
      branch_id: branch_id,
      user_id: user_id,
      is_disabled: false
    }
    leaf = Leaf.where(where).limit(1)
    if !leaf[0]
      branch = Branch.find(branch_id)
      cond = where.merge({
        branch_parent_id: branch.parent_id
      })
      leaf = Leaf.new(cond)
      leaf.save
      QueueBranch.add(branch_id)
    else
      leaf = leaf[0]
    end
    leaf
  end

  def updt_parents
    branch = self.branch
    while(branch.parent_id != 0) do
      Leaf.get(branch.parent_id, self.user_id)
      branch = branch.parent
    end
  end

  def updt_content(text)
     if text && text != ""
      content = Content.find_or_create_by_leaf_id(self.id)
      content.text = text
      content.save
      self.content_id = content.id
      self.branch.update_attribute('content_at', Time.now)
    end
    self
  end

  def updt_fav_num
    self.fav_num = Fav.where(
      :leaf_id => self.id,
      :is_disabled => false
    ).count
    self.save
  end

  def fav?(user_id)
    fav = Fav.where(
      :leaf_id => self.id,
      :user_id => user_id,
      :is_disabled => false
    ).limit(1)
    fav[0] ? true : false
  end

  def change_branch_id(new_parent_id)
    parent_id = parent_id.to_i
    if new_parent_id && new_parent_id > 0 && self.branch_id != new_parent_id
      old_branch = Branch.get(self.branch_id)
      new_branch = Branch.get(new_parent_id).child(
        old_branch.title_id
      )
      if old_branch.id != new_branch.id
        old_branch.children.each do |old_branch_child|
          if old_branch_child.has_leaf?(self.user_id)
            old_leaf_child = old_branch_child.leaf(self.user_id)
            old_leaf_child.change_branch_id(
              new_branch.id
            )
          end
        end
        self.branch_id = new_branch.id
        self.save
      end
      new_branch.leaf(self.user_id).updt_parents
      Report.create({
        :branch_id => old_branch.id,
        :user_id => self.user_id
      }) if old_branch.parent.parent_id != 0
      QueueBranch.add(old_branch.id)
      QueueBranch.add(new_branch.id)
      LogMoveWord.add(old_branch.id, new_branch.id, self.user_id)
    else
      false
    end
    self
  end

  def updt_is_disabled(str)
    if str == "true" 
      self.is_disabled = false
    elsif str == "false"
      self.is_disabled = true
    else
      #do nothing
    end
    self
  end

  def self.updt_is_disabled_by_branch_id(branch_id, user_ids)
    branch = Branch.find(branch_id)
    Leaf.where(
      :branch_id => branch_id,
      :is_disabled => false,
      :user_id => user_ids
    ).update_all(
      :is_disabled => true
    )
    children = Branch.where(
      :parent_id => branch_id
    )
    children.each do |child|
      Leaf.updt_is_disabled_by_branch_id(child.id, user_ids)
    end
    branch.updt_leaf_num_bottomup
  end

  def self.updt_branch_parent_ids
    Leaf.where("branch_parent_id is null and branch_id != 0").each do |leaf|
      leaf.updt_branch_parent_id
    end
  end

  def updt_branch_parent_id
    begin
      Branch.find(self.branch_id)
      self.branch_parent_id = branch.parent_id
      self.save
    rescue
    end
  end
end
