window.id = Math.floor(location.hash.replace(/^[^#]*#/,''))
window.vim_focus_now = 0
window.vim_focus_prev = 0
window.vim_is_input = 0
window.use_words = true

$(document).ready(() ->
  window.user_id = $('#user_id').attr('data-user_id')
  if use_words == false
    $.get(
      "/all_data",
      (msg) ->
        window.all_data = msg
        init(id)
    )
  else
    init(id)

  $(window).bind("hashchange", () ->
    id = Math.floor(location.hash.replace(/^[^#]*#/,''))
    id = 0 if id == ''
    init(id)
  )
  $('*').keypress((e) ->
    window.prepare_vim(e.which)
  )
  $('*').keyup((e) ->
    if which_to_key(e.which) == 'esc'
      vim_esc()
  )
)

window.init = (id)->
  window.id = Math.floor(location.hash.replace(/^[^#]*#/,''))
  $('#new_textarea').css('display','none')
  window.vim_focus_now = 0
  location.hash = id
  if use_words
    $.get(
      "/words/"+ id + '?user_id=' + user_id,
      (data) ->
        base(data)
    )
  else
    children = []
    for child_id in window.all_data.branches[id].children
      child = all_data.branches[child_id]
      if all_data.titles[child_id]
        children.push({
          branch_id: child_id,
          title: all_data.titles[child_id],
          is_leaf: all_data.user_branches[child.id],
          leaf_num: child.leaf_num,
          parent_id: child.parent_id,
        })
    data = {
      breadcrumbs: {}, #TODO
      children: children
    }
    base(data)

  if id != 0
    $('#new_textarea').css('display','none')
    $.get(
      "/words/"+ id + '/contents',
      (msg) ->
        if msg[0] && msg[0].content
          content = msg[0].content
        else
          content = ""
        $('#new_textarea').val(content)
        $('#new_textarea').css('display','block')
    )
  else
    $('#new_textarea').css('display', 'none')
    $('#new_input').css('display', 'none')



