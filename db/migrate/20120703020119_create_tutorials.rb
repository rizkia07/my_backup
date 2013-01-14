class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.string :title
      t.integer :branch_id
      t.string :key
      t.integer :val
      t.integer :previous_id
      t.integer :point

      t.timestamps
    end
  end
end
