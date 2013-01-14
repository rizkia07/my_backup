class TutorialUser < ActiveRecord::Base
  attr_accessible :tutorial_id, :user_id, :goal_at, :cancel_at, :val
  belongs_to :user
  belongs_to :tutorial

  def self.get(user_id)
    res = TutorialUser.where(
      :user_id => user_id
    ).where(
      "goal_at is null"
    ).where(
      "cancel_at is null"
    ).limit(1)
    while(!res)
      res = []
      Tutorial.where(
        "id > ?", self.tutorial_id
      ).limit(1).each do |tutorial|
        tutorial_user = TutorialUser.geta(
          user_id,
          tutorial.id
        )
        res.push(
          tutorial_user
        ) if tutorial_user.updt.active?
      end
    end
    res
  end

  def self.geta(user_id, tutorial_id)
    TutorialUser.find_or_create_by_user_id_and_tutorial_id(
      user_id,
      tutorial_id
    )
  end

  def updt
    if self.goal?
      self.goal_at = Time.now
      self.save
    end
    updt_val
    self
  end

  def updt_val
    if self.tutorial.key == "has_leaf"
      self.val = self.user.count_leaf
    elsif self.tutorial.key == "has_branch"
      self.val = self.user.count_branch
    else
      # do nothing
    end 
    self.save
  end

  def goal?
    case self.tutorial.key
    when "has_leaf"
      has_leaf?
    when "has_branch"
      has_branch?
    when "has_special_leaf"
      has_special_leaf?
    when "has_child_leaf"
      has_child_leaf?
    when "has_twitter_id"
      has_twitter_id?
    else
      false
    end 
  end

  def has_leaf?
    self.user.count_leaf >= self.tutorial.val ? true : false
  end

  def has_branch?
    self.user.count_branch >= self.tutorial.val ? true : false
  end

  def has_special_leaf?
    leaf = Leaf.where(
      :branch_id => self.branch_id,
      :is_disabled => false,
      :user_id => self.user_id
    )
    leaf[0] ? true : false
  end

  def has_child_leaf?
    res = false
    branch_id = self.branch_id
    branch = Branch.find(self.branch_id)
    branch.children.each do |child|
      leaf = Leaf.where(
        :branch_id => child.id,
        :is_disabled => false,
        :user_id => self.user_id
      )
      res = true if leaf[0]
    end
    res
  end

  def has_twitter_id?
    self.user.twitter_id ? true : false
  end

  def branch_id
    case self.user.lang_id
    when 1
      self.tutorial.branch_id_en
    when 2
      self.tutorial.branch_id_ja
    end
  end
end
