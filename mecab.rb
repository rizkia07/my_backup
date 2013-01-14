# -*r coding: utf-8 -*-
require 'MeCab'
puts "hoge"
data = "すももももももももものうち"                 # 解析文字列

c = MeCab::Tagger.new

n = c.parse(data)

raise n.inspect

# 形態素ごとループ
while n do
  type = n.feature.split(",")[0] # 品詞 

  raise type.inspect

  if type == "名詞"              # 名詞のみ出力
    puts n.surface
  end

  n = n.next                     # 次に移動
end
