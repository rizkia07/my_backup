class AddTitleLocalToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :title_c, :string
  end
end
