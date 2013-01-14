class AddIsFixedToTitle < ActiveRecord::Migration
  def change
    add_column :titles, :is_fixed, :boolean, {:default => false}
  end
end
