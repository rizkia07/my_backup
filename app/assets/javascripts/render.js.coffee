window.renderBread = (bread) ->
  res = ''
  if bread && bread[0]
    for i in bread
      if i.branch_id == 0
        res = '<li>' + i.title + '</li>' + res
      else
        res = """
        <li class="word">
        <a href=\"##{i.branch_id}\">#{i.title}</a>
        <span class="divider">/</span></li>""" + res
    res = '''<li class="word">
      <a href="/#0">TOP</a>
      <span class="divider">/</span></li> ''' + res
  res

window.renderWord = (word, n) ->
  res = ''
  cls = ''
  if word
    checked = ''
    if word.is_leaf == true
      checked = ' checked="nochecked"'
    else
      cls = ' nochecked'
    if word.title.match(/^https?:\/\//)
      type = 'url'
    else
      type = 'title'

    if Math.floor(word.branch_id) == Math.floor(localStorage['vim_yanked'])
      yanked = " yanked"
    else
      yanked = ""
    res += """
    <li class=\"word#{type} span2#{cls}#{yanked}\" id=\"w#{n}\">
    <label class=\"checkbox\">
    <input type=\"checkbox\"#{checked} 
    class=\"check_leaf\" value=\"#{word.branch_id}\"
      data-id = \"#{word.branch_id}\" 
      id = \"#{word.branch_id}\" 
    />
    """
    if word.title.match(/^https?:\/\//)
      res += """[url]<a href=\"#{word.title}\" 
      target=\"_blank\" 
      data-id=\"#{word.branch_id}\">#{word.url_name}"""
    else
      res += """<a href=\"##{word.branch_id}\"
      data-id=\"#{word.branch_id}\">#{word.title}"""
    res += """
      </a>(#{word.leaf_num})
      </label>
      </li>"""
  res
