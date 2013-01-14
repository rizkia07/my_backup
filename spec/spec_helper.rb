# -*r coding: utf-8 -*-
require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
  end
end

Spork.each_run do
end

def rspec_login(id)
  @request.session = ActionController::TestSession.new
  user = User.find(id)
  @request.session[:user] = user
end

def rspec_logout
  @request.session[:user] = nil
end

User.delete_all
Branch.delete_all
Leaf.delete_all
Title.delete_all
Fav.delete_all
Url.delete_all
QueueBranch.delete_all
Theme.delete_all

user = User.add
user.name = "name_1"
user.lang_id = 2
user.save

user2 = User.add
user2.name = "name_2"
user2.lang_id = 2
user2.save


TutorialData.init

params = {}
params[:words] = {
  :title => "English",
  :parent_id => 0,
  :user_id => SpecData.user('name_1').id,
  :content => "English"
}
Word.create(params[:words])

params = {}
params[:words] = {
  :title => "日本語",
  :parent_id => 0,
  :user_id => SpecData.user('name_1').id,
  :content => "日本語"
}
Word.create(params[:words])

(1..30).each do |i|
  params = {}
  params[:words] = {
    :title => i.to_s,
    :parent_id => SpecData.branch('日本語').id,
    :user_id => SpecData.user('name_1').id,
    :content => "this is content of " + i.to_s
  }
  Word.create(params[:words])
end

(1..30).each do |i|
  params = {}
  params[:words] = {
    :title => "1_" + i.to_s,
    :parent_id => SpecData.branch('1').id,
    :user_id => SpecData.user('name_1').id,
    :content => "this is content of 1_" + i.to_s
  }
  Word.create(params[:words])
end

(1..5).each do |i|
  params = {}
  params[:words] = {
    :title => i.to_s,
    :parent_id => SpecData.branch('日本語').id,
    :user_id => SpecData.user('name_2').id,
    :content => "this is content of " + i.to_s
  }
  Word.create(params[:words])
end

(1..5).each do |i|
  params = {}
  params[:words] = {
    :title => i.to_s,
    :parent_id => SpecData.branch('1').id,
    :user_id => SpecData.user('name_2').id,
    :content => "this is content of 1_" + i.to_s
  }
  Word.create(params[:words])
end

params = {}
params[:words] = {
  :title => "from_a",
  :parent_id => SpecData.branch('日本語').id,
  :user_id => SpecData.user('name_1').id,
  :content => "this is content of from_a"
}
Word.create(params[:words])

(1..10).each do |i|
  params = {}
  params[:words] = {
    :title => "from_a_" + i.to_s,
    :parent_id => SpecData.branch('from_a').id,
    :user_id => SpecData.user('name_1').id,
    :content => "this is content of from_a_" + i.to_s
  }
  Word.create(params[:words])
end

(1..10).each do |i|
  params = {}
  params[:words] = {
    :title => "from_a_1_" + i.to_s,
    :parent_id => SpecData.branch('from_a_1').id,
    :user_id => SpecData.user('name_1').id,
    :content => "this is content of from_a_1_" + i.to_s
  }
  Word.create(params[:words])
end

params = {}
params[:words] = {
  :title => "to_a",
  :parent_id => SpecData.branch('日本語').id,
  :user_id => SpecData.user('name_2').id,
  :content => "this is content of to_a"
}
Word.create(params[:words])

(1..5).each do |i|
  params = {}
  params[:words] = {
    :title => "to_a_" + i.to_s,
    :parent_id => SpecData.branch('to_a').id,
    :user_id => SpecData.user('name_2').id,
    :content => "this is content of to_a_" + i.to_s
  }
  Word.create(params[:words])
  QueueBranch.do_cron
end

TutorialData.init
Theme.new({
  :date => Time.now,
  :branch_id => SpecData.branch('1').id
}).save
Theme.new({
  :date => Time.now,
  :branch_id => SpecData.branch('1_1').id
}).save

