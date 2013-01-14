class AddLangIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :lang_id, :integer, {:default => 1}
  end
end
