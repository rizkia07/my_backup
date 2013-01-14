class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :branch_id
      t.integer :lang_id

      t.timestamps
    end
  end
end
