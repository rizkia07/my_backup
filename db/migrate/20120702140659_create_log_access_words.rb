class CreateLogAccessWords < ActiveRecord::Migration
  def change
    create_table :log_access_words do |t|
      t.integer :user_id
      t.integer :word_id
      t.integer :branch_id

      t.timestamps
    end
  end
end
