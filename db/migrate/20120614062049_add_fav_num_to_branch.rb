class AddFavNumToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :fav_num, :integer
  end
end
