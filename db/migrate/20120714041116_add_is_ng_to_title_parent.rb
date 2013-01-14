class AddIsNgToTitleParent < ActiveRecord::Migration
  def change
    add_column :title_parents, :is_ng, :boolean
  end
end
