class ChangeUser < ActiveRecord::Migration
  def change
    remove_column :users, :tutorial_val
    remove_column :users, :tutorial_id
    remove_column :users, :point
    remove_column :users, :token
    remove_column :users, :img
    remove_column :users, :email
    remove_column :users, :pass
    add_column :tutorial_users, :val, :integer, {:default => 0}
    remove_column :tutorials, :val_ja
    add_column :tutorials, :branch_id_en, :integer
    add_column :tutorials, :branch_id_ja, :integer
    
  end
end
