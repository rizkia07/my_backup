class CreateFeedReads < ActiveRecord::Migration
  def change
    create_table :feed_reads do |t|
      t.integer :user_id
      t.integer :feed_entry_id
      t.boolean :is_read, :default => false

      t.timestamps
    end
  end
end
