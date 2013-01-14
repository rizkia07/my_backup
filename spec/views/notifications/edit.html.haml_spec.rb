require 'spec_helper'

describe "notifications/edit" do
  before(:each) do
    @notification = assign(:notification, stub_model(Notification,
      :user_id => 1,
      :body => "MyText",
      :lang_id => 1
    ))
  end

  it "renders the edit notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notifications_path(@notification), :method => "post" do
      assert_select "input#notification_user_id", :name => "notification[user_id]"
      assert_select "textarea#notification_body", :name => "notification[body]"
      assert_select "input#notification_lang_id", :name => "notification[lang_id]"
    end
  end
end
