class CreateTitleChildren < ActiveRecord::Migration
  def change
    create_table :title_children do |t|
      t.integer :title_id
      t.integer :child_id
      t.integer :title_num, {:default => 0}

      t.timestamps
    end
  end
end
