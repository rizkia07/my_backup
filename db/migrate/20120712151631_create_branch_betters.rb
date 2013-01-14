class CreateBranchBetters < ActiveRecord::Migration
  def change
    create_table :branch_betters do |t|
      t.integer :branch_id
      t.integer :better_branch_id
      t.integer :val, {:default => 0}

      t.timestamps
    end
    add_column :branches, :better_id, :integer
  end
end
