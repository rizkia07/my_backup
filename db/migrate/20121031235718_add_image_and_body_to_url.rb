class AddImageAndBodyToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :image, :text
    add_column :urls, :body, :text
  end
end
