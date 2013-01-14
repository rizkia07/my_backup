class AddLangIdToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :lang_id, :integer
  end
end
