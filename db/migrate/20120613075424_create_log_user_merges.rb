class CreateLogUserMerges < ActiveRecord::Migration
  def change
    create_table :log_user_merges do |t|
      t.integer :old_user_id
      t.integer :new_user_id

      t.timestamps
    end
  end
end
