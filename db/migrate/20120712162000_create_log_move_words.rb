class CreateLogMoveWords < ActiveRecord::Migration
  def change
    create_table :log_move_words do |t|
      t.integer :user_id
      t.integer :branch_id
      t.integer :new_branch_id

      t.timestamps
    end
  end
end
