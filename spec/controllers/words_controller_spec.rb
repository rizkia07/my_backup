# -*r coding: utf-8 -*-
require 'spec_helper'
describe WordsController, :type => :controller do
  describe "GET /words/0 (root)" do
    Word.show(SpecData.user('name_1').id, SpecData.branch('日本語').id)[:children].count.should >= 0
  end

  describe "GET /words/0 by user_2" do
    Word.show(SpecData.user('name_2').id, SpecData.branch('日本語').id)[:children].count.should >= 0
  end

  describe "GET /words/:id (title_1) " do
    Word.show(SpecData.user('name_1').id, SpecData.branch('1').id)[:children].count.should >= 0
  end

  describe "GET /words/:id (title_1_1)" do
    Word.show(SpecData.user('name_1').id, SpecData.branch('1_1').id)[:children].count.should==0
  end

  describe "move from fromA to toA" do
    leaf = SpecData.branch('from_a_1').leaf(SpecData.user('name_1').id)
    leaf2 = SpecData.branch('from_a_1_1').leaf(SpecData.user('name_1').id)
    leaf.branch.parent_id.should == SpecData.branch('from_a').id
    leaf2.branch.parent_id.should == SpecData.branch('from_a_1').id
    SpecData.branch('from_a_1').leaf(SpecData.user('name_1').id).should_not(nil)
    SpecData.branch('from_a_1_1').leaf(SpecData.user('name_1').id).should_not(nil)
    data = {
      :words => {
        :parent_id => SpecData.branch('to_a').id,
        :user_id => SpecData.user('name_1').id
      }
    }
    Word.update(SpecData.branch('from_a_1').id, data[:words])
    leaf = Leaf.find(leaf.id)
    leaf.branch.parent_id.should == SpecData.branch('to_a').id
    leaf2 = Leaf.find(leaf2.id)
=begin
    leaf2.branch.leaf(1).id.should == Branch.where(
      :parent_id => leaf.branch.id,
      :title_id => leaf2.branch.title.id
    ).limit(0)[0].leaf(0).id
=end
    SpecData.branch('from_a_1').leaf(SpecData.user('name_1').id).should(nil)
    SpecData.branch('from_a_1_1').leaf(SpecData.user('name_1').id).should(nil)
  end

  QueueBranch.do_cron

end
