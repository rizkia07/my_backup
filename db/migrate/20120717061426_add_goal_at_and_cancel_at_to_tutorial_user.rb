class AddGoalAtAndCancelAtToTutorialUser < ActiveRecord::Migration
  def change
    add_column :tutorial_users, :goal_at, :datetime
    add_column :tutorial_users, :cancel_at, :datetime
  end
end
