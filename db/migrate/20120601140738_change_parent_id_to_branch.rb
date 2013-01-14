class ChangeParentIdToBranch < ActiveRecord::Migration
  def change
    change_column :branches, :parent_id, :integer, {:defalut => 0}
  end
end
