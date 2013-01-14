class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :title_id
      t.integer :parent_id
      t.integer :leaf_num
      t.integer :user_id

      t.timestamps
    end
  end
end
