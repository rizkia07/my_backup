class CreateFavs < ActiveRecord::Migration
  def change
    create_table :favs do |t|
      t.integer :user_id
      t.integer :leaf_id
      t.boolean :is_disabled

      t.timestamps
    end
  end
end
