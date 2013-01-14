class CreateQueueModels < ActiveRecord::Migration
  def change
    create_table :queue_models do |t|
      t.boolean :is_done, {:default => false}
      t.integer :title_id

      t.timestamps
    end
  end
end
