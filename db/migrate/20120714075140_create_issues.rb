class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :tracker_id
      t.string :subject
      t.text :description
      t.date :due_date
      t.integer :category_id
      t.integer :status_id
      t.integer :assigned_to_id
      t.integer :priority_id
      t.integer :author_id
      t.integer :parent_id
      t.integer :root_id

      t.timestamps
    end
  end
end
