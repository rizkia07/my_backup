class AddTutorialValToUser < ActiveRecord::Migration
  def change
    add_column :users, :tutorial_val, :integer, {:default => 0}
  end
end
