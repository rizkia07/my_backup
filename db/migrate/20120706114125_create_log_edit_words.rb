class CreateLogEditWords < ActiveRecord::Migration
  def change
    create_table :log_edit_words do |t|
      t.integer :user_id
      t.integer :branch_id
      t.integer :new_branch_id
      t.integer :parent_id
      t.integer :old_parent_id
      t.boolean :is_leaf

      t.timestamps
    end
  end
end
