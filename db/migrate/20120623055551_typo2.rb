class Typo2 < ActiveRecord::Migration
  def change
    rename_table :title_children, :title_parents
  end
end
