require "spec_helper"

describe WordsController do
  describe "routing" do
    it "routes to #show" do
      get("/words/1").should route_to(
        :controller => 'words',
        :action => 'show',
        :id => "1"
      )
    end

    it "routes to #create" do
      post("/words").should route_to(
        :controller => 'words',
        :action => 'create',
      )
    end

    it "routes to #update" do
      put("/words/1").should route_to(
        :controller => 'words',
        :action => 'update',
        :id => "1"
      )
    end
  end
end
