class Content < ActiveRecord::Base
  attr_accessible :leaf_id, :text
  belongs_to :leaf

  def self.get(branch_id, user_id = 0)
    res = []
    content = ""
    fav_num = 0
    is_fav = false

    if user_id != 0
      branch = Branch.get(branch_id)
      if branch.has_leaf?(user_id)
        leaf = branch.leaf(user_id)
        is_fav = leaf.fav?(user_id)
        if leaf.content
          content = leaf.content.text
          fav_num = leaf.fav_num
        end
      end
    end
    viewer_content = {
      :user_id => user_id,
      :content => content,
      :fav_num => fav_num,
      is_fav: is_fav,
    }
    viewer_content[:leaf_id] = leaf.id if content != ""

    Leaf.where(
      :branch_id => branch_id,
      :is_disabled => false 
    ).each do |leaf|
      if leaf.content && leaf.user_id.to_i != user_id.to_i
        res.push({
          user_id: leaf.user_id,
          leaf_id: leaf.id,
          fav_num: leaf.fav_num,
          is_fav: leaf.fav?(user_id),
          content: leaf.content.text
        })
      end
    end
    res = res.sort_by!{|i|-i[:fav_num]}
    res = [viewer_content] + res
    res
  end

  def self.wikip
    Title.all.each do |parent_title| 
      begin 
        xml = Net::HTTP.get_response(URI.parse("http://ja.wikipedia.org/wiki/%E7%89%B9%E5%88%A5:%E3%83%87%E3%83%BC%E3%82%BF%E6%9B%B8%E3%81%8D%E5%87%BA%E3%81%97/" + CGI.escape(parent_title.name))).body
        body = Crack::XML.parse(xml)
        if body
          puts parent_title.name + ' is in wikipedia'
          Title.all.each do |child_title| 
            if body['mediawiki']['page']['revision']['text'].match(child_title.name) && parent_title != child_title
              parent_branch = Branch.get(0, parent_title.id)
              parent_leaf = Leaf.get(parent_branch.id, 0)
              child_branch = Branch.get(parent_branch.id, child_title.id)
              parent_leaf = Leaf.get(child_branch.id, 0)
            end
          end
        end 
      rescue
        puts parent_title.name + ' is not in wikipedia'
      end 
    end 
    "done"
  end 

  def self.updt_branch_content_at  #for console
    Content.all.each do |content|
      content.leaf.branch.update_attribute('content_at', content.updated_at) if content && content.leaf && content.leaf.branch
    end
  end
end
