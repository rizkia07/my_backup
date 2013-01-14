class ChangeHotAtToTitleUser < ActiveRecord::Migration
  def down
    change_column :title_users, :hot_at, :datetime, {:default => "2000-01-01 00:00:00"}
  end
end
