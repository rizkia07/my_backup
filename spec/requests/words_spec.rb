require 'spec_helper'

describe "Words" do
  describe "GET /words/:id (title_1_1)" do
    it "works! (now write some real specs)" do
      get "/#{SpecData.branch(1).id}?user_id=#{SpecData.user('name_1').id}"
      response.status.should be(200)
    end
  end

  describe "GET /words/:id (title_1)" do
    it "works! (now write some real specs)" do
      get "/#{SpecData.branch(1).id}?user_id=#{SpecData.user('name_1').id}"
      response.status.should be(200)
    end
  end
end
