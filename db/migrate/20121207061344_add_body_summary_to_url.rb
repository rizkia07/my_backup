class AddBodySummaryToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :body_summary, :text
  end
end
