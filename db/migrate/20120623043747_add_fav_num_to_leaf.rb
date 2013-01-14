class AddFavNumToLeaf < ActiveRecord::Migration
  def change
    add_column :leafs, :fav_num, :integer
  end
end
