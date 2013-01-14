class AddBranchParentIdToLeaf < ActiveRecord::Migration
  def change
    add_column :leafs, :branch_parent_id, :integer
  end
end
