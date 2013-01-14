class LogEditWord < ActiveRecord::Base
  attr_accessible :branch_id, :is_leaf, :parent_id, :user_id, :new_branch_id, :old_parent_id

  def self.add(word)
    keys = [
      :user_id,
      :branch_id,
      :new_branch_id,
      :parent_id,
      :old_parent_id,
      :is_leaf
    ]
    data = {}
    keys.each do |key|
      data[key] = word[key] if word[key]
    end
    LogEditWord.new(data).save
  end
end
