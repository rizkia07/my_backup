class CreateTitleUsers < ActiveRecord::Migration
  def change
    create_table :title_users do |t|
      t.integer :title_id
      t.integer :user_id
      t.integer :point, {:default => 0}
      t.datetime :checked_at
      t.datetime :canceled_at

      t.timestamps
    end
  end
end
