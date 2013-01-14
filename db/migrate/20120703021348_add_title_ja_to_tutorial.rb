class AddTitleJaToTutorial < ActiveRecord::Migration
  def change
    add_column :tutorials, :title_ja, :string
  end
end
