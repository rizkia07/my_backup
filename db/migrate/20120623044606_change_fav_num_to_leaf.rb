class ChangeFavNumToLeaf < ActiveRecord::Migration
  def change
    change_column :leafs, :fav_num, :integer, {:default => 0}
  end
end
