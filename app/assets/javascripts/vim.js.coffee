window.vim_focus = (key) ->
  n = window.vim_focus_now
  $('#w' + n).removeClass('focus')
  if vim_focus_now == 0
    window.vim_focus_now = 1
  else
    if key == 'up'
      window.vim_focus_now = vim_focus_now + 1
    else if key == 'down'
      window.vim_focus_now = vim_focus_now - 1
  n = window.vim_focus_now
  $('#w' + n).addClass('focus')

window.vim_check = () ->
  n = vim_focus_now
  $li = $($('#w' + n)[0])
  $a = $($('#w' + n + ' a')[0])
  $check = $($('#w' + n + ' input')[0])
  if $check.attr('checked') == "checked"
    $check.removeAttr('checked')
    $li.addClass('checked')
  else
    $check.attr('checked', 'checked')
    $li.removeClass('checked')
  do_check($check)

window.vim_input = () ->
  $('#new_input').css('display', 'block')
  $('#new_input').focus()
  window.vim_is_input = 1

window.vim_textarea = () ->
  $('#new_textarea').css('display', 'block')
  $('#new_textarea').focus()
  window.vim_is_input = 2

window.vim_enter = () ->
  href = $("#w#{vim_focus_now} a").attr('href')
  if typeof(href) != 'undefined' && href.match(/^http/)
    window.open(href,'_blank')
  else
    id = vim_focus_now
    vim_focus_prev = i
    i = $("#w#{id} a").attr('data-id')
    init(i)

window.vim_esc = () ->
  localStorage['vim_yanked'] = 0
  init(id)
  #location.reload()

window.vim_paste = () ->
  console.log "vim_yanked is " + localStorage['vim_yanked']
  console.log "viewing id is " + id
  if localStorage['vim_yanked'] != "0"
    move(Math.floor(localStorage['vim_yanked']), id)

window.vim_yank = () ->
  vim_yanked = localStorage['vim_yanked']
  if $('#'+vim_yanked)[0]
    $($($('#'+vim_yanked).parents()[0]).parents()[0]).removeClass('yanked')
  $f = $('#w'+vim_focus_now)
  $f.addClass("yanked")
  localStorage['vim_yanked'] = $('#w'+vim_focus_now).find('input').attr('data-id')


window.which_to_key = (key) ->
  data = {
    27: 'esc', 97: 'a', 105: 'i', 103: 'g', 106: 'j', 107: 'k', 112: 'p',
    121: 'y', 104: 'h', 13: 'enter', 32: 'space'
  }
  return data[key]

window.vim_do = (which) ->
  if vim_is_input == 0
    key = which_to_key(which)
    switch key
      when 'i' then vim_input()
      when 'a' then vim_textarea()
      when 'g' then init(2)
      when 'j' then vim_focus('up')
      when 'k' then vim_focus('down')
      when 'h' then init(vim_focus_prev)
      when 'y' then vim_yank()
      when 'p' then vim_paste()
      when 'enter' then vim_enter()
      when 'space' then vim_check()

window.prepare_vim = (which) ->
  if vim_is_input == 0
    vim_do(which)
    false
  else if vim_is_input == 1
    if which_to_key(which) == 'enter'
      if $('#new_input').val() == ''
        $('#new_input').val('')
        $('#new_input').css('display', 'none')
      else
        add()
      window.vim_focus_now = 0
      window.vim_is_input = 0
      false
  else if vim_is_input == 2
    if which_to_key(which) == 'enter'
      if $('#new_textarea').val() == ''
        $('#new_textarea').val('')
        $('#new_textarea').css('display', 'none')
      else
        updt_content()
      window.vim_focus_now = 0
      window.vim_is_input = 0
      false
