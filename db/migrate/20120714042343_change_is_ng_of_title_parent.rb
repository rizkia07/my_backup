class ChangeIsNgOfTitleParent < ActiveRecord::Migration
  def change
    change_column :title_parents, :is_ng, :boolean, {:default => false}
  end
end
