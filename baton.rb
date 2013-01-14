# -*r coding: utf-8 -*-
require 'net/http'
require 'uri'
require 'json'
class Render
  def ls(breadcrumbs, children)
    render_breadcrumbs(breadcrumbs) + render_children(children)
  end

  def render_breadcrumbs(breadcrumbs)
    res = "["
    breadcrumbs.each do |val|
      res += "#{val} > "
    end
    res += "] "
  end

  def render_children(children)
    res = ""
    i = 1
    children.each do |key, val|
      res += "#{(i).to_s}. #{val[:title]} "
      i = i +1
    end
    res
  end
end

app_token = nil
print "please input token.\n"
branch_id = 2

while line = gets.chomp
  app_token = gets.chomp #todo 
  breadcrumbs = ["日本語"]
  children = {}
  if app_token
    url = URI.parse("http://baton.mindia.jp/words/#{branch_id}?app_token=da692dc01c24691679033238cd688d4f24d058e9e292e381e41f4f0271fc20a2&user_id=170")
    json = Net::HTTP.get_response(url).body
    data = JSON.parse(json)
    i = 1
    data["children"].each do |child|
      children[i] = {title: child["title"], branch_id: child["branch_id"]}
    end
    render = Render.new
    print render.ls(breadcrumbs, children)
    if line == (/exit/ =~ line)
      break 
    elsif line[0] == ":"
      print "go to  #{line.sub(/^:/,'')}\n"
    elsif line == ""
      #do nothing
    elsif line == "ls"
      print render.ls(breadcrumbs, children)
    elsif line == "cd /"
      branch_id = 2
    elsif line.match(/^cd/)
      branch_id = children[line.replace(/^cd /, '').to_i][:branch_id]
      print "go to #{branch_id}"
    else
      children[i] = [{:title => "#{line}(1)"}]
      #print render.ls(breadcrumbs, children)
    end
  else
    print "This token is invalid. please input token again.\n"
  end
end
