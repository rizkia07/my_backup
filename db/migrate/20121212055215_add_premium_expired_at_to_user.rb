class AddPremiumExpiredAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :premium_expired_at, :datetime
  end
end
