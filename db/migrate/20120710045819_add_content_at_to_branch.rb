class AddContentAtToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :content_at, :datetime
    add_column :branches, :fav_at, :datetime
    add_column :favs, :to_user_id, :integer
    add_column :contents, :user_id, :integer
  end
end
