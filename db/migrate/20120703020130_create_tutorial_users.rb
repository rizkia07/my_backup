class CreateTutorialUsers < ActiveRecord::Migration
  def change
    create_table :tutorial_users do |t|
      t.integer :tutorial_id
      t.integer :user_id

      t.timestamps
    end
    add_column :users, :tutorial_id, :integer, {:default => 0}
    add_column :users, :point, :integer, {:default => 0}
  end
end
