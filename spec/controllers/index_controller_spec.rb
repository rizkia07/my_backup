require 'spec_helper'
describe IndexController, :type => :controller do
=begin
  describe "GET / without login" do
    #before { rspec_logout }
    describe :routes do
      subject { { :get => "/" } }
      it { should route_to( controller: "index", action: "index") }
    end
    before { get :index}
    describe :response do
      subject { response }
      it { response.should render_template('index') }
    end
  end

  describe "GET / with login" do
    #before { rspec_login(1) }
    before { get :index }
    it { response.should render_template('index') }
    it 'success' do
      response.should be_success
    end
  end

  describe "GET /help" do
  end

  describe "GET /api" do
  end
=end
end
