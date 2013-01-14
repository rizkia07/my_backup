class CreateLogAccesses < ActiveRecord::Migration
  def change
    create_table :log_accesses do |t|
      t.integer :user_id
      t.string :ctrlr
      t.string :actn
      t.string :params

      t.timestamps
    end
  end
end
