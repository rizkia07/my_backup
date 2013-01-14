class ChangeTutorial < ActiveRecord::Migration
  def change
    remove_column :tutorials, :title_ja
    remove_column :tutorials, :point
    remove_column :tutorials, :branch_id
  end
end
