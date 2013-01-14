class AddChildNumToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :child_num, :integer, {:default => 0}
  end
end
