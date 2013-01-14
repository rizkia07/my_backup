class FromIsFixedToBranchIdInTitle < ActiveRecord::Migration
  def change
    remove_column :titles, :is_fixed
    add_column :titles, :branch_id, :integer
  end
end
