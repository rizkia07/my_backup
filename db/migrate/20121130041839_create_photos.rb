class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :flickr_id
      t.string :url_q
      t.string :page
      t.string :username
      t.string :realname
      t.string :query
      t.text :info

      t.timestamps
    end
  end
end
