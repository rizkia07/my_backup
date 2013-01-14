def word_show(enter, out)
  describe "show" do
    word = Word.show(enter[:user_id], enter[:id])
    if enter[:id].to_i != 0
      it "breadcrumbs should have #{out[:dir]}" do
        word[:breadcrumbs].count.should == out[:dir]
      end
    end
    it "children" do
      children = Branch.get(enter[:id]).children_pop(enter[:user_id])
      word[:children].count.should > 0 
    end
  end
end

def word_create(enter, out)
  describe "create" do
    Word.create(enter)
    title = Title.find_by_name(enter[:title])
    branch = Branch.find_by_parent_id_and_title_id(
      enter[:parent_id],
      title.id
    )
    it "title" do
      enter[:title].should == title.name
    end
  end
end

def word_update(enter, out)
  describe "update" do
    leaf = Leaf.find_by_branch_id_and_user_id(
      enter[:id].to_i,
      enter[:words][:user_id]
    )
    Word.update(enter[:id], enter[:words])
    leaf = Leaf.find(leaf.id)
    it "parent_id" do
      leaf.branch.parent_id.should == enter[:words][:parent_id]
    end
  end
end
