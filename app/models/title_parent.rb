class TitleParent < ActiveRecord::Base
  attr_accessible :child_id, :title_id, :title_num, :is_ng
  belongs_to :title

  def self.hide(branch) #TODO
    self.add_is_ng(branch)
  end

  def self.add_is_ng(branch)
    TitleParent.where(
      :title_id => branch.title_id,
      :parent_id => branch.parent.title_id
    ).update_all(:is_ng => true)
  end
end
