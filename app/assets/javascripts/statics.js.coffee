# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if !window.console
  window.console = {
    log: ->
  } 

$ ->
  console.log 'test'

  return if !/statics#?$/.test(location.href)

  currentCategory = 
    branchId: 2 
    title: 'Baton'

  $batonList = $('.js_baton_list')
  $batonSubList = $('.js_baton_sub_list')

  $featuresNav = $('.js_features_nav')
  $featuresContent = $('.js_features_content')

  children = []
  currentIndex = 7

  # get initial baton list
  $.get("/words/#{currentCategory.branchId}.json?user_id=1", (data) ->
    if data && data.children
      for child in data.children.slice(0, currentIndex)
        $baton = $("<li><i class=\"color\"></i><i class=\"check\"></i><a href=\"#\" data-branch-id=\"#{child.branch_id}\">#{child.title}</a></li>")
        $batonList.append($baton)
      children = data.children
      #setTimeout(rotateBaton, 3000)
  )

  # rotate baton list
  rotateBaton = ->
    child = children[currentIndex]
    console.log(child)
    currentIndex++
    if currentIndex > children.length
      currentIndex = 0
    $baton = $("<li><i class=\"color\"></i><i class=\"check\"></i><a href=\"#\" data-branch-id=\"#{child.branch_id}\">#{child.title}</a></li>")
    $baton.height(0)
    $batonList.append($baton)

    #$batonList.find('li:first').animate({ height: 0 }, 'normal', ->
    $batonList.find('li:first').animate({ "margin-top": -40 }, 'normal', ->
      $(this).remove()
    )
    $batonList.find('li:last').animate({ height: 40 }, 'normal', ->
    )

    setTimeout(rotateBaton, 3000)

  # change feature content
  $featuresNav.on('click', 'a', (e) ->
    e.preventDefault()
    index = $featuresNav.find('a').index(this) 
    $featuresNav.find('.current').removeClass('current')
    $featuresContent.find('.current').removeClass('current')
    $(this).addClass('current')
    $featuresContent.find('.content').eq(index).addClass('current')
  )
  $featuresNav.find('a:eq(0)').click()

  # click root list
  $batonList.on('click', 'a', (e) ->
    e.preventDefault()
    $this = $(this)
    branchId = $this.data('branchId')
    console.log(branchId)

    getSubCategory(branchId)
  )

  # click sub list
  $batonSubList.on('click', 'a', (e) ->
    e.preventDefault()
    $this = $(this)
    branchId = $this.data('branchId')
    console.log(branchId)

    getSubCategory(branchId)
  )

  getSubCategory = (branchId) ->
    $.get("/words/#{branchId}.json?user_id=1", (data) ->
      if data && data.children
        $batonSubList.html('')
        for child in data.children.slice(0, currentIndex)
          $baton = $("<li><i class=\"color\"></i><i class=\"check\"></i><a href=\"#\" data-branch-id=\"#{child.branch_id}\">#{child.title}</a></li>")
          $batonSubList.append($baton)
    )

