# -*r coding: utf-8 -*-
class Branch < ActiveRecord::Base
  attr_accessible :leaf_num, :parent_id, :title_id, :user_id, :content_at, :parent_num, :child_num, :id, :lang_id, :is_ng
  belongs_to :title
  belongs_to :parent, :class_name => 'Branch', :foreign_key => "parent_id"
  belongs_to :better, :class_name => 'Branch', :foreign_key => "better_id"
  has_many :children, :class_name => 'Branch', :foreign_key => "parent_id"

  def self.get(id)
    id = id.to_i
    res = (id == 0 ? Branch.new : self.find_by_id(id))
    res.id = 0 if id == 0
    res
  end

  def children_hash(user_id)
    #start_time = Time.now

    res = []
    self.children_pop(user_id).each do |branch|
      is_leaf = branch.has_leaf?(user_id)
      title = branch.title
      child = {
        :branch_id => branch.id,
        :title => title.name,
        :is_leaf => is_leaf,
        :leaf_num => branch.leaf_num,
        :right_num => branch.leaf_num
      }
      url = title.url
      if url.present?
        child = child.merge({
          :url_name => url.name,
          :url_image => url.image.to_s,
          :url_body => url.body_summary.to_s[0..255],
          :url_favicon => url.favicon.to_s
        }) 
      end
      child = child.merge(branch.get_photo)
      res += [child]
    end
    res

    #end_time = Time.now
    #raise "Time: #{(end_time - start_time) * 1000}ms"
  end

  def children_pop(user_id)
    branch_ids = Leaf.where(
      :branch_parent_id => self.id,
      :user_id => user_id,
      :is_disabled => false
    ).pluck(:branch_id)
    branches = []
    branches += self.by_branch_ids(branch_ids) if branch_ids[0]
    if branches.count < 30
      branches += self.by_not_in_branch_ids(
        branch_ids,
        (30 - branches.count)
      )
    end
    if branches.count < 30 && self.id > 100
      title_ids = branches.map{|i| i.title.id}
      TitleParent.where(
        'title_id not in (?)',
        title_ids, 
      ).where( 
        :parent_id => self.title.id,
        :is_ng => false
      ).order(
        'title_num desc'
      ).limit(30 - branches.count).map{|i| 
        Branch.find_or_create_by_parent_id_and_title_id(
          self.id,
          i.title_id
        )
      }.each do |branch|
        branches += [branch] if !branch.is_ng
      end
    end
    branches
  end

  def has_leaf?(user_id)
    leaf(user_id) ? true : false
  end

  def leaf(user_id)
    leaf = Leaf.where(
      :branch_id => self.id,
      :user_id => user_id,
      :is_disabled => false
    )
    leaf[0] ? leaf[0] : nil
  end

  def get_leaf(user_id)
    user_id = user_id.to_i
    Leaf.get(self.id, user_id)
  end

  def child(title_id, user_id=nil)
    cond = {
      parent_id: self.id,
      title_id: title_id
    }
    branch = Branch.where(cond).limit(1)
    if !branch[0]
      branch = Branch.new(cond)
      branch.user_id = user_id
      branch.leaf_num = 1
      branch.is_ng = 0
      branch.save
      QueueTitle.add(branch.title_id)
      branch.updt_lang_id
      branch.updt_parent_num
    else
      branch = branch[0]
      branch.is_ng = 0
      branch.leaf_num = 1 if (branch.leaf_num < 1)
      branch.save
    end
    branch
  end

  def breadcrumbs
    res = []
    if self.id > 100
      i = self.id
      while(i > 100) do 
        puts i
        branch = Branch.get(i)
        i = branch.parent_id
        parent = {
          branch_id: branch.id, 
          title: branch.title.name
        }
        parent[:url_name] = branch.title.url.name if branch.title.url_id
        res.push(parent)
      end
    end
    res
  end

  def get_photo
    if self.title.photo.present?
      photo = self.title.photo
      return {
        :photo_url_q => photo.url_q.to_s,
        :photo_page => photo.page.to_s,
        :photo_username => photo.username.to_s, 
      }
    end
    return {}
  end

  def updt_lang_id(lang_id = nil)
    if !lang_id 
      if self.parent_id == 0
        lang_id = self.id
      else
        parent = self.parent
        while(parent.parent_id != 0)
          parent = parent.parent
        end
        lang_id = parent.id
      end
    end
    self.children.each do |child_branch|
      child_branch.updt_lang_id(lang_id)
    end
    self.update_attribute('lang_id', lang_id)
  end

  def updt_child_num_topdown
    child_num = 0
    Branch.where(
      :is_ng => false,
      :parent_id => self.id,
    ).each do |child|
      i = child.updt_child_num_topdown + 1
      child_num += i
    end
    self.update_attribute('child_num', child_num)
    child_num
  end

  def updt_child_num_bottomup
    child_num = self.updt_child_num_topdown
    parent = self.parent
    while(parent && parent.parent_id != 0) do
      parent.updt_child_num_bottomup
      parent = parent.parent
    end
  end

  def updt_leaf_num_topdown
    leaf_num = self.count_leaf_num
    self.children.each do |child_branch|
      leaf_num += child_branch.updt_leaf_num_topdown
    end
    self.update_attribute('leaf_num', leaf_num) 
    leaf_num
  end

  def updt_leaf_num_bottomup(depth = 0)
    leaf_num = self.count_leaf_num
    self.children.each do |child_branch|
      leaf_num += child_branch.leaf_num
    end
    self.update_attribute('leaf_num', leaf_num)
    parent = self.parent
    while(parent && parent.parent_id > 0 && !parent.fixed? && depth < 2) do
      depth += 1
      parent.updt_leaf_num_bottomup(depth)
      parent = parent.parent
      puts "depth is #{depth}"
    end
  end

  def count_leaf_num
    Leaf.where(
      :branch_id => self.id,
      :is_disabled => false
    ).count
  end

  def updt_fav_num
    fav_num = 0
    leafs = Leaf.where(
      :branch_id => self.id,
      :is_disabled => false
    )
    leafs.each do |leaf|
      fav_num = leaf.fav_num
    end
    self.fav_num = fav_num
    self.save
  end

  def self.ids_by_user(user_id)
    res = {}
    Leaf.where(
      :user_id => user_id,
      :is_disabled => false
    ).each do |leaf|
      res[leaf.branch_id] = true 
    end
    res
  end

  def self.all_data
    res = {}
    Branch.select(
      'id, title_id, parent_id, leaf_num'
    ).each do |branch|
      children = []
      children = res[branch.id][:children] if res[branch.id]
      res[branch.id] = {
        title_id: branch.title_id,
        parent_id: branch.parent_id,
        leaf_num: branch.leaf_num,
        children: children
      }
      res[branch.parent_id] = {:children => []} if !res[branch.parent_id]
      res[branch.parent_id][:children] += [branch.id]
    end
    res
  end

  def by_branch_ids(branch_ids)
    Branch.where(
      'id in (?) and is_ng = 0',
      branch_ids
    ).order(
      'leaf_num desc'
    )
  end

  # Suggestion
  def by_not_in_branch_ids(branch_ids, limit=30)
    cond = self.id < 100 ? "is_fixed = 1" : nil
    Branch.where(
      branch_ids.blank? ? nil : ["id not in (?)", branch_ids]
    ).where(
      "leaf_num > 0" 
    ).where(cond).where(
      :parent_id => self.id,
      :is_ng => false,
    ).order(
      'leaf_num desc'
    ).limit(limit)
  end

  def fixed?
    self.is_fixed
  end
  
  def self.find_by_breadcrumbs(data)
    parent_id = 0
    branch = nil
    data.each do |name|
      branch = Branch.find_or_create_by_title_id_and_parent_id(
        Title.get(name).id,
        parent_id
      )
      parent_id = branch.id
    end
    branch
  end

  def updt_children_better_id
    self.better_id = self.parent.better.child(self.title_id).id
    self.save
    self.children.each do |child|
      child.updt_children_better_id
    end
  end

  def text_breadcrumbs
    res = (self.parent_id == 0 ? "Home" : self.title.name)
    parent = self.parent
    while(parent && parent.parent_id != 0)
      res = "#{parent.title.name} > " + res 
      parent = parent.parent
    end
    res
  end

  def updt_parent_num_topdown(parent_num)
    self.update_attribute('parent_num', parent_num)
    self.children.each do |child|
      child.updt_parent_num_topdown(parent_num + 1)
    end
  end

  def updt_parent_num
    self.parent_num  = 1
    if parent_id != 0
      parent = self.parent
      while(parent.parent_id != 0)
        self.parent_num = self.parent_num + 1
        parent = parent.parent
      end
    end
    self.save
  end

  def add_search_links
    return if self.id < 100
    return if self.title.url?
    query = CGI.escape(self.title.name)

    google = add_google_link(query)
    google.get_leaf(1) if google.present?

    wikipedia = add_wikipedia_link(query)
    wikipedia.get_leaf(1) if wikipedia.present?

    if self.parent_id > 100
      return if self.parent.title.url?
      parent_query = CGI.escape(self.parent.title.name)
      parent_google = add_google_link("#{query}+#{parent_query}")
      parent_google.get_leaf(1) if parent_google.present?
    end
  end


  def add_google_link(query)
    add_link("http://www.google.com/search?q=#{query}")
  end

  def add_wikipedia_link(query)
    locale = self.lang_id == 2 ? 'ja' : 'en'
    add_link("http://#{locale}.m.wikipedia.org/wiki/#{query}")
  end

  def get_link(url)
    title = Title.get(url)
    branch = Branch.where(
      parent_id: self.id,
      title_id: title.id
    ).first
    return branch
  end
 
  def add_link(url)
 
    link = get_link(url)
    return link if link.present?

    word = Word.create(
      :user_id => 1,
      :parent_id => self.id,
      :title => url,
    )
    branch = Branch.find(word[:branch_id])
    branch.title.updt_url

    # set ng if 404
    if branch.title.url.nil?
      Report.create(
        :branch_id => branch.id,
        :user_id => branch.user_id,
      )
      return
    end

    branch.leaf_num = 1
    branch.save
    return branch
  end

  # for console
  def self.updt_lang_ids
    Branch.update_all(:lang_id => nil)
    Branch.where(:parent_id => 0).each do |branch|
      branch.updt_lang_id(branch.id)
    end
  end

  def self.updt_leaf_nums_topdown
    Branch.where(:parent_id => 0).each do |branch|
      branch.updt_leaf_num_topdown
    end
  end

  def self.updt_child_nums_topdown
    Branch.where(:parent_id => 0).each do |branch|
      branch.updt_child_num_topdown
    end
  end

  def self.updt_parent_nums_topdown
    Branch.where(:parent_id => 0).each do |branch|
      branch.updt_parent_num_topdown(1)
    end
  end

  def self.sdata(name)
    title = Title.find_by_name(name)
    Branch.find_by_title_id(title.id)
  end
end
