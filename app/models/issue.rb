class Issue < ActiveRecord::Base
  attr_accessible :assigned_to_id, :author_id, :category_id, :description, :due_date, :parent_id, :priority_id, :root_id, :status_id, :subject, :tracker_id

end
