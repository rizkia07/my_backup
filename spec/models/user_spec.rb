require 'spec_helper'

describe User do

  fixtures :users

  describe "User validation testing" do
		before(:each) do
		  @attr = {name: users(:user_1).name, twitter_id: users(:user_1).twitter_id}
		end

		after(:each) do
		  @user.should_not be_valid
		  @user.errors.size.should_not be_nil
		end

		it "should be uniqueness" do
		  User.create(@attr)
		  @user=User.new(@attr)
		end


		it "should require data" do
		  @user = User.new
		end
	end

  it "should clear fixtures"do
  users(:user_1).destroy
    lambda{users(:user_1).reload}.should raise_error(ActiveRecord::RecordNotFound)
  end
end
