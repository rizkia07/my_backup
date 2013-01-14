class UpdtBranchLeafNum < ActiveRecord::Migration
  def down
    change_column :branches, :leaf_num, :integer, {:default => 0}
  end
end
