class SetDefaultToIsDisabledToLeaf < ActiveRecord::Migration
  def change
    change_column :leafs, :is_disabled, :boolean, {:default => false}
  end
end
