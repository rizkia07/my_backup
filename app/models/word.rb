# -*r coding: utf-8 -*-
class Word
  def self.show(user_id, id = 0)
    branch = Branch.get(id)
    LogAccessWord.plus(user_id, {
      :title_id => branch.title_id,
      :branch_id => branch.id
    })
    if id == 2
      res = {
        :breadcrumbs => [],
        :children => [
          {:branch_id => 7451, :title => "生活", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
          {:branch_id => 9264, :title => "エンタメ", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
          {:branch_id => 765, :title => "ビジネス", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
          {:branch_id => 9034, :title => "クリエイティブ", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
          {:branch_id => 402, :title => "歴史", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
          {:branch_id => 119, :title => "旅行", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
          {:branch_id => 12457, :title => "政治", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
          {:branch_id => 25039, :title => "環境", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
          {:branch_id => 1078, :title => "科学", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
          {:branch_id => 15032, :title => "未分類", :is_leaf => true, :leaf_num => 9999, :right_num => 9999},
        ]
      }
    else
      res = {
        :breadcrumbs => branch.breadcrumbs,
        :children => branch.children_hash(user_id)
      }
      branch.get_leaf(user_id)
    end
    res
  end

  def self.create(word)
    title = Title.get(word[:title])
    if title
      user = User.find(word[:user_id].to_i)
      branch = Branch.get(
        word[:parent_id]
      ).child(title.id, user.id)
      leaf = branch.get_leaf(user.id)
      leaf.updt_content(word[:content])

      word[:branch_id] = branch[:id]
      word[:is_leaf] = true
      user.updt_tutorial
      QueueLeaf.add(leaf.id) if user.id != 1
    end
    LogEditWord.add(word)
    word
  end

  def self.update(branch_id, word)
    user = User.find(word[:user_id].to_i)
    branch = Branch.get(
      branch_id.to_i
    )
    word[:old_parent_id] = branch.parent_id if word[:parent_id] && branch.parent_id != word[:parent_id].to_i
    leaf = branch.get_leaf(
      user.id 
    ).change_branch_id(
      word[:parent_id].to_i
    ).updt_is_disabled(
      word[:is_leaf]
    ).updt_content(
      word[:content]
    )
    leaf.save
    word[:branch_id] = branch_id
    word[:new_branch_id] = leaf.branch_id if branch_id.to_i != leaf.branch_id
    LogEditWord.add(word)
    QueueLeaf.add(leaf.id)
    user.updt_tutorial
    word
  end
end
