class CreateCategories < ActiveRecord::Migration
  def change
    create_table :issue_categories do |t|
      t.string :title

      t.timestamps
    end
  end
end
