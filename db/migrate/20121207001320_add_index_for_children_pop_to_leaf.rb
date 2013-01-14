class AddIndexForChildrenPopToLeaf < ActiveRecord::Migration
  def change
    add_index :leafs, [:branch_parent_id, :user_id, :is_disabled], :unique => false
  end
end

