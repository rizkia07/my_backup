class Fav < ActiveRecord::Base
  attr_accessible :is_disabled, :leaf_id, :user_id
  belongs_to :leaf
  def self.create(fav, leaf_id)
    begin 
      leaf = Leaf.find(leaf_id)
      fav = Fav.find_or_create_by_user_id_and_leaf_id_and_is_disabled(
        fav[:user_id].to_i,
        leaf.id,
        false,
      )
      fav.leaf.updt_fav_num
      fav.leaf.branch.updt_fav_num
      fav.leaf.branch.update_attribute('fav_at', Time.now)
    rescue
      "invalid leaf_id"
    end
  end

  def self.destroy(fav, leaf_id)
    begin 
      leaf = Leaf.find(leaf_id)
      fav = Fav.find_by_user_id_and_leaf_id_and_is_disabled(
        fav[:user_id].to_i,
        leaf.id,
        false,
      )
      fav.is_disabled = true
      fav.save
      fav.leaf.updt_fav_num
      fav.leaf.branch.updt_fav_num
    rescue
      "invalid leaf_id"
    end
  end
end
