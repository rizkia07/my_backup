class Typo < ActiveRecord::Migration
  def change
    rename_table :queue_models, :queue_titles
  end
end
