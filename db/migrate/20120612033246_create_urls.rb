class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.text :title
      t.text :url

      t.timestamps
    end
  end
end
