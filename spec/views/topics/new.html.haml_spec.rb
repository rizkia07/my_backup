require 'spec_helper'

describe "topics/new" do
  before(:each) do
    assign(:topic, stub_model(Topic,
      :branch_id => 1,
      :lang_id => 1
    ).as_new_record)
  end

  it "renders new topic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => topics_path, :method => "post" do
      assert_select "input#topic_branch_id", :name => "topic[branch_id]"
      assert_select "input#topic_lang_id", :name => "topic[lang_id]"
    end
  end
end
