class SetDefaultToTitleParentTitleNum < ActiveRecord::Migration
  def change
    change_column :title_parents, :title_num, :integer, {:default => 0}
  end
end
