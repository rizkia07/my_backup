class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.integer :user_id
      t.text :text
      t.string :issue_id
      t.integer :status_id

      t.timestamps
    end
  end
end
