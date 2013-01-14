require 'spec_helper'
describe "Hots" do
  describe "GET /hots" do
    it "works!" do
      get "/hots?app_token=#{SpecData.user('name_1').app_token}"
      response.status.should be(200)
    end
  end
end
