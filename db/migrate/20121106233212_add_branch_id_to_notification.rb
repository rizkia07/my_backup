class AddBranchIdToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :branch_id, :integer
  end
end
