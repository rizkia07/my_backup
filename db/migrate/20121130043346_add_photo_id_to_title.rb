class AddPhotoIdToTitle < ActiveRecord::Migration
  def change
    add_column :titles, :photo_id, :integer
  end
end
