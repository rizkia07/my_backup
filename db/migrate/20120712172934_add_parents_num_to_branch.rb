class AddParentsNumToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :parent_num, :integer
  end
end
