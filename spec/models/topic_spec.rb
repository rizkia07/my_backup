require 'spec_helper'

describe Topic do
  before(:each) do
    @attr = {branch_id: 2, lang_id: 4}
  end

  	after(:each) do
		  @topic.should_not be_valid
		  @topic.errors.size.should_not be_nil
		end

		it "should be uniqueness" do
		  Topic.create(@attr)
		  @topic=Topic.new(@attr)
		end

		it "should require data" do
		  @topic = Topic.new
		end

		it "should exist in database" do
		  @topic = Topic.new(@attr)
		end

end
