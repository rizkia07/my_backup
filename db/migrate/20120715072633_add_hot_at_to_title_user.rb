class AddHotAtToTitleUser < ActiveRecord::Migration
  def change
    add_column :title_users, :hot_at, :datetime, {:default => "0000-00-00 00:00:00"}
  end
end
