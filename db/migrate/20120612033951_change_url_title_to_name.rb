class ChangeUrlTitleToName < ActiveRecord::Migration
  def change
    rename_column :urls, :title, :name
    add_column :titles, :url_id, :integer
  end
end
