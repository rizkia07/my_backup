class BranchBetter < ActiveRecord::Base
  attr_accessible :branch_id, :better_branch_id, :val
  belongs_to :branch
 
  def self.updt
    BranchBetter.delete_all
    Branch.update_all(:better_id => nil)

    LogEditWord.where("parent_id is not null").each do |i|
      BranchBetter.add(i.branch_id, i.new_branch_id) if i.new_branch_id && i.branch_id != i.new_branch_id
    end

    BranchBetter.select('distinct branch_id').each do |i|
      bb = BranchBetter.where(
        :branch_id => i.branch_id
      ).order(
        "val desc"
      ).limit(1).first
      branch = bb.branch
      branch.better_id = bb.better_branch_id
      branch.save
      branch.children.each do |child|
        child.updt_children_better_id
      end
    end

    Branch.where(
      "better_id is null"
    ).where(
      "parent_id in (0,1,2)"
    ).where(
      :is_fixed => false
    ).each do |branch|
      better_branch = Branch.where(
        :title_id => branch.title_id,
        :is_ng => false,
      ).order('leaf_num desc').limit(1).first
      if better_branch && better_branch.id !=  branch.id
        branch.better_id = better_branch.id
        branch.save
      end
    end
  end

  def plus1
    self.val = self.val + 1
    self.save
  end

  def self.add(branch_id, new_branch_id)
    BranchBetter.find_or_create_by_branch_id_and_better_branch_id(
      branch_id,
      new_branch_id
    ).plus1
  end

end
