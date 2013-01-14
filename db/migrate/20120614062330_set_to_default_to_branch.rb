class SetToDefaultToBranch < ActiveRecord::Migration
  def change
    change_column :branches, :fav_num, :integer, {:default => 0}
  end
end
