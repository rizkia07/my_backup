class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.text :body
      t.integer :lang_id

      t.timestamps
    end
  end
end
