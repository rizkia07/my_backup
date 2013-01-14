require 'spec_helper'
describe TitlesController, :type => :controller do
  describe "GET /titles/hoge" do
    describe :routes do
      subject { {:get => "/titles/hoge"} }
      it { should route_to(controller: "titles", action: "show", id: "hoge")}
    end
    before { get :show, :id => "hoge"}
    describe :response do
      subject { response }
      it { should be_success}
    end
  end
end
