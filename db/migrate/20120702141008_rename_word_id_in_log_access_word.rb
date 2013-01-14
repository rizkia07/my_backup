class RenameWordIdInLogAccessWord < ActiveRecord::Migration
  def change
    rename_column :log_access_words, :word_id, :title_id
  end
end
