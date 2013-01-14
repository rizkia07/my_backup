require 'spec_helper'

describe "topics/edit" do
  before(:each) do
    @topic = assign(:topic, stub_model(Topic,
      :branch_id => 1,
      :lang_id => 1
    ))
  end

  it "renders the edit topic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => topics_path(@topic), :method => "post" do
      assert_select "input#topic_branch_id", :name => "topic[branch_id]"
      assert_select "input#topic_lang_id", :name => "topic[lang_id]"
    end
  end
end
