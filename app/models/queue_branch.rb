class QueueBranch < ActiveRecord::Base
  attr_accessible :is_done, :branch_id
  belongs_to :branch

  def self.add(branch_id)
    QueueBranch.find_or_create_by_is_done_and_branch_id(
      false,
      branch_id
    )
  end

  def self.do_cron
    cond = {
      :is_done => false
    }
    QueueBranch.where(cond).each do |i|
      if i.branch_id != 0
        branch = Branch.find(i.branch_id)
        branch.updt_leaf_num_bottomup
        #branch.updt_child_num_bottomup
        branch.updt_parent_num
        i.is_done = true
        i.save
        branch.add_search_links()
      end
    end
  end
end
