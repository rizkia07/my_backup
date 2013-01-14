class AddAppTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :app_token, :string
  end
end
