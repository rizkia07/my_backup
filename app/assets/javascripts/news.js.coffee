# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if !window.console
  window.console = {
    log: ->
  } 

$ ->
  return if !$('#news').length

  # Constants
  USER_ID = 1

  # Utilities

  search = (e) ->
    console.log('hoge')
    e.preventDefault()

    query = $searchQuery.val()

    $searchResult.html('')

    $.get("/titles/#{query}.json?user_id=#{USER_ID}&lang_id=#{lang()}", (data) ->
      html = ['<ul>']
      for d in data
        html.push("<li>#{d.title} #{d.branch_id}</li>")
      html.push('<ul>')
      $searchResult.html(html.join(''))
    )

  addTopic = (e) ->
    e.preventDefault()

    data = $(this).serialize()
    data += "&lang_id=#{lang()}"

    $topicResult.html('')

    $.ajax(
      type: 'post',
      url: "/news/topic",
      data: data,
      success: (data) ->
        $topicResult.html(data)
    )

  addNotification = (e) ->
    e.preventDefault()

    data = $(this).serialize()
    data += "&lang_id=#{lang()}"

    $notificationResult.html('')

    $.ajax(
      type: 'post',
      url: "/news/notification",
      data: data,
      success: (data) ->
        $notificationResult.html(data)
    )


  lang = ->
    return $('input[name="lang"]:checked').val()

  # Cache
  $searchQuery = $('#search_query')
  $searchResult = $('#search_result')
  $topicResult = $('#topic_result')
  $notificationResult = $('#notification_result')

  # Events
  $('#search_form').on('submit', search)
  $('#topic_form').on('submit', addTopic)
  $('#notification_form').on('submit', addNotification)

