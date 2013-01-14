# -*r coding: utf-8 -*-
class Hoge
  def self.fuga(org_id=13004692)
    user = User.find_by_org_id(org_id)
    if !user
      user = User.add
      user.org_id = org_id
      user.save
    end
    word = Word.create({
      :user_id => user.id,
      :parent_id => 2,
      :title => "環境"
    })
    branch = Branch.find(word[:branch_id])
    branch.is_fixed = true
    branch.save
    #File.open("/Users/nishiko/git/tree/hoge.txt", "r") do |f|
    File.open("/var/www/git/baton/hoge.txt", "r") do |f|
      f.each do |text|
        text.split(/\n/).each do |line|
          parent = nil
          line.split('  ').each do |word|
            if parent
              parent_id = parent[:branch_id]
            else
              parent_id = 0
            end
            parent = Word.create({
              :user_id => user.id,
              :parent_id => parent_id,
              :title => word
            })
          end
        end
      end
    end
=begin
    #File.open("/Users/nishiko/git/tree/hoge2.txt", "r") do |f|
    File.open("/var/www/git/baton/hoge2.txt", "r") do |f|
      f.each do |text|
        text.split(/\n/).each do |line|
          parent = nil
          is_content = true
          line.split('  ').each do |word|
            content = word; is_content = false; next if is_content
            parent_id = (parent ? parent[:branch_id] : 0 )
            parent = Word.create({
              :user_id => user.id,
              :parent_id => parent_id,
              :title => word
            })
          end
          Word.update(
            parent[:branch_id],
            {
              :content => content
            }
          )
        end
      end
    end
=end
  end

  def self.tweet_test(id)
    user = User.find(id)
    twitter_client = Twitter::Client.new(
      :oauth_token        => user.twitter_token,
      :oauth_token_secret => user.twitter_secret
    )
    twitter_client.update("Test: #{Time.now}")
  end

end
