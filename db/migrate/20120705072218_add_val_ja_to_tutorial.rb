class AddValJaToTutorial < ActiveRecord::Migration
  def change
    add_column :tutorials, :val_ja, :integer
  end
end
