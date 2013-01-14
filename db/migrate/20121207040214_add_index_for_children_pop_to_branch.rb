class AddIndexForChildrenPopToBranch < ActiveRecord::Migration
  def change
    add_index :branches, [:parent_id, :title_id], :unique => false
  end
end
