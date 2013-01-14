require 'spec_helper'

describe "notifications/new" do
  before(:each) do
    assign(:notification, stub_model(Notification,
      :user_id => 1,
      :body => "MyText",
      :lang_id => 1
    ).as_new_record)
  end

  it "renders new notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notifications_path, :method => "post" do
      assert_select "input#notification_user_id", :name => "notification[user_id]"
      assert_select "textarea#notification_body", :name => "notification[body]"
      assert_select "input#notification_lang_id", :name => "notification[lang_id]"
    end
  end
end
