class AddIsDisabledToLeaf < ActiveRecord::Migration
  def change
    add_column :leafs, :is_disabled, :boolean
  end
end
