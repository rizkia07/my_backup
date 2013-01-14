class SetDefaltToBranch < ActiveRecord::Migration
  def change
    change_column :branches, :leaf_num, :integer, {:default => 0}
  end
end
