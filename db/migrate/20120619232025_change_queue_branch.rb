class ChangeQueueBranch < ActiveRecord::Migration
  def change
    remove_column :queue_branches, :leaf_id
    add_column :queue_branches, :branch_id, :integer
  end
end
