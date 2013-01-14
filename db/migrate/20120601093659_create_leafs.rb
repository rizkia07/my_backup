class CreateLeafs < ActiveRecord::Migration
  def change
    create_table :leafs do |t|
      t.integer :branch_id
      t.integer :content_id
      t.integer :user_id

      t.timestamps
    end
  end
end
