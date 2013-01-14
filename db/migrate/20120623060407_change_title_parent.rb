class ChangeTitleParent < ActiveRecord::Migration
  def change
    rename_column :title_parents, :child_id, :parent_id
  end
end
