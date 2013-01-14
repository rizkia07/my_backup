# -*r coding: utf-8 -*-
 class TutorialData 
  def self.init
    data = [
      {
        :title => "tutorial1",
        :key => "has_special_leaf",
        :val => Branch.find_by_breadcrumbs(["English", "Entertainment"]).id,
        :val_ja => Branch.find_by_breadcrumbs(["日本語", "エンタメ"]).id
      },
      {
        :title => "tutorial2",
        :key => "has_child_leaf_1",
        :val => Branch.find_by_breadcrumbs(["English", "Entertainment"]).id,
        :val_ja => Branch.find_by_breadcrumbs(["日本語", "エンタメ"]).id
      },
      {
        :title => "tutorial3",
        :key => "has_twitter_id",
      }
=begin
      {
        :title => "Let's check the 5 batons you are interested in",
        :title_ja => "チェックを5個つけよう！",
        :key => "has_leaf",
        :val => 5
      },
      {
        :title => "Let's add 5 batons via \"+\" button",
        :title_ja => "「＋」で新しいバトンを5つ作ろう！",
        :key => "has_branch",
        :val => 5
      },
      {
        :title => "Let's check the 20 batons you are interested in",
        :title_ja => "チェックを20個つけよう！",
        :key => "has_leaf",
        :val => 20
      },
      {
        :title => "Let's add 20 batons via \"+\" button",
        :title_ja => "「＋」で新しいバトンを20つ作ろう！",
        :key => "has_branch",
        :val => 20
      },
      {
        :title => "Let's check the 100 batons you are interested in",
        :title_ja => "チェックを100個つけよう！",
        :key => "has_leaf",
        :val => 100
      },
      {
        :title => "Let's add 100 batons via \"+\" button",
        :title_ja => "「＋」で新しいバトンを100つ作ろう！",
        :key => "has_branch",
        :val => 100
      },
      {
        :title => "Let's check the 1000 batons you are interested in",
        :title_ja => "チェックを1000個つけよう！",
        :key => "has_leaf",
        :val => 1000
      },
      {
        :title => "Let's add 1000 batons via \"+\" button",
        :title_ja => "「＋」で新しいバトンを1000つ作ろう！",
        :key => "has_branch",
        :val => 1000
      }
=end
    ]
=begin
    data.each do |i|
      if Tutorial.where(:title => i[:title]).blank?
        Tutorial.new(i).save
      end
    end
    User.update_all(:tutorial_id => Tutorial.first.id)
    Tutorial.all.each do |tutorial|
      User.all.each do |user|
        TutorialUser.find_or_create_by_tutorial_id_and_user_id(
          tutorial.id,
          user.id
        ).updt
      end
    end
=end
  end
end
