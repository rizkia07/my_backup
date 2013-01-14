class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.integer :branch_id
      t.date :date

      t.timestamps
    end
  end
end
