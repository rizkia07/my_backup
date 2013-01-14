class AddIsFixedToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :is_fixed, :boolean, {:default => false}
  end
end
