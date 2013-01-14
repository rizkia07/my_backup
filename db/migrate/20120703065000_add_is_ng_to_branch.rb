class AddIsNgToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :is_ng, :boolean, {:default => false}
  end
end
