# -*r coding: utf-8 -*-
require 'spec_helper'
require 'models/word_helper'

describe Word do
=begin
  describe ".show" do
    describe "in dir 0 (root)" do
      enter = {
        :user_id => SpecData.user('name_1').id,
        :id => SpecData.branch('日本語').id
      }
      out = {
        :dir => 0
      }
      word_show(enter, out)
    end
    describe "dir 1" do
      enter = {
        :user_id => SpecData.user('name_1').id,
        :id => SpecData.branch('1').id
      }
      out = {
        :dir => 0
      }
      word_show(enter, out)
    end
    describe "dir 2" do
      enter = {
        :user_id => SpecData.user('name_1').id,
        :id => SpecData.branch('1_1').id
      }
      out = {
        :dir => 1
      }
      word_show(enter, out)
    end
  end
=end
  describe ".create" do
    describe "dir 0 (root)" do
      enter = {
        :title => "created_title",
        :parent_id => SpecData.branch('1').id,
        :user_id => SpecData.user('name_1').id
      }
      out = {
      }
      word_create(enter, out)
    end
  end

  describe ".update" do
    describe "dir 0 (root)" do
      enter = {
        :id => SpecData.branch('created_title').id,
        :words => {
          :parent_id => SpecData.branch('2').id,
          :user_id => SpecData.user('name_1').id,
          :content => "moved from 1 to 2"
        }
      }
      out = {
      }
      word_update(enter, out)
    end
  end
end
