require 'spec_helper'

describe Notification do
before(:each) do
    @attr = {user_id: 9999999999, lang_id: 777, title: "Title", branch_id: 9999999999}
        @attr2 = {user_id: 1, lang_id: 1, title: "Title2", branch_id: 1}
  end

  	after(:each) do
		  @notification.should_not be_valid
		  @notification.errors.size.should_not be_nil
		end

		it "should be uniqueness" do
		  Notification.create(@attr2)
		  @notification=Notification.new(@attr2)
		end

		it "should require data" do
		  @notification = Notification.new
		end

		it "should exist in database" do
		  @notification = Notification.new(@attr)
		end
end
