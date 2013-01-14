class CreateQueueLeafs < ActiveRecord::Migration
  def change
    create_table :queue_leafs do |t|
      t.boolean :is_done
      t.integer :leaf_id

      t.timestamps
    end
  end
end
