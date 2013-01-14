window.base = (msg) ->
  res = ""
  n = 1
  window.children = msg.children
  for child in children
    res += renderWord(child, n)
    n = n + 1
  $('#words').html(res)

  if id != 0
    bread = renderBread(msg.breadcrumbs)
  else
    bread = ""
  $('.breadcrumb').html(bread)
  prepare()

window.add = () ->
  if $('#new_input').val().replace(' 　','') != ''
    parent_id = location.hash.replace(/^[^#]*#/,'')
    parent_id = Math.floor(parent_id)
    words = {words:{
        user_id: user_id,
        parent_id: parent_id,
        title: $('#new_input').val(),
      }
    }
    $.post(
      "/words", words, (msg) ->
        children.unshift(msg)
        n = 1
        res = ""
        for child in children
          res += renderWord(child, n)
          n = n + 1
        $('#words').html(res)
        prepare()
        $('#new_input').val('')
        $('#new_input').css('display', 'none')
        return false
    )
    return false

window.updt_content = () ->
  $val = $('#new_textarea').val()
  $val = $val.replace(' 　', '')
  if $val != ''
    words = {
      words:{
        user_id: user_id,
        content: $('#new_textarea').val(),
      }
    }
    $.ajax({
      type: "PUT",
      url: "/words/" + id,
      data: words,
      success: (msg) ->
        alert('本文を更新しました！')
    })



window.prepare = () ->
  $('.check_leaf').click(() ->
    do_check($(this))
  )
  $('.word').draggable()
  $('.word').droppable({
      accept: '.word',
      hoverClass: "orange-hover",
      drop: ( event, ui ) ->
        ui.draggable.css('display', 'none')
        target_id  = Math.floor($($(ui.draggable[0]).find('a')[0]).attr('data-id'))
        parent_id  = Math.floor($($(this).find('a')[0]).attr('data-id'))
        move(target_id, parent_id)
  })

window.move = (target_id, parent_id) ->
  words = {words:{
      user_id: user_id,
      parent_id: parent_id
    }
  }
  $.ajax({
    type: "PUT",
    url: "/words/#{target_id}",
    data: words,
    success: (msg) ->
      localStorage['vim_yanked'] = 0
      init(parent_id)
      #location.reload()
  })

window.do_check = ($check) ->
  $check = $($check[0])
  branch_id = $check.attr('data-id')
  words = {
    words:{
      user_id: user_id,
      is_leaf: $check.is(':checked')
    }
  }
  $.ajax({
    type: "PUT",
    url: "/words/#{branch_id}",
    data: words,
    success: (msg) ->
  })

