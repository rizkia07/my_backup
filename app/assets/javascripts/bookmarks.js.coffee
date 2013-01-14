# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if !window.console
  window.console = {
    log: ->
  } 

$ ->
  return if !$('#bookmarks').length

  LINK_TEXT_MAX = 50

  currentCategory = 
    branchId: 2 
    title: 'Baton'

  categories = [currentCategory]

  $categoryForm = $('.js_category_form')
  $categoryField = $('.js_category_field')
  $suggestResult = $('.js_suggest_result')
  $currentCategories = $('.js_current_categories')
  $contentForm = $('.js_content_form')
  $contentField = $('.js_content_field')
  $contentCount = $('.js_content_count')
  $contentMessage = $('.js_content_message')
  $contentTitle = $('.js_content_title')
  $categoryBranchId = $('.js_category_branch_id')

  # get suggests
  #$categoryField.keyup ->

  getSubCategories = ->

    query = $categoryField.val()
    #if !query || query.length < 2
    #if !query
    #  return

    $suggestResult.html('')

    #$.get("/titles/#{query}.json?user_id=#{SESSION.id}&lang_id=2", (data) ->
    #$.get("/titles/#{query}.json?lang_id=#{langId}", (data) ->
    $.get("/words/#{currentCategory.branchId}.json?user_id=#{SESSION.id}", (data) ->
      if data && data.children
        for child in data.children
          matchFlag = if query && child.title.indexOf(query) > -1 then 'match' else ''
          if (!child.url_name)
            $suggest = $("<li><a href=\"#\" data-branch-id=\"#{child.branch_id}\" class=\"suggest #{matchFlag}\"><span class=\"label\">#{child.title}</span></a></li>")
          else
            title = if child.url_name.length < LINK_TEXT_MAX then child.url_name else "#{child.url_name.slice(0, LINK_TEXT_MAX)}..."
            $suggest = $("<li><a href=\"#{child.title}\" data-branch-id=\"#{child.branch_id}\" class=\"link\" target=\"_blank\"><span class=\"label\">#{title} <i class=\"icon-share\"></i></span></a></li>")

          $suggestResult.append($suggest)
    )

  # select suggest
  $suggestResult.on('click', 'a.suggest', (e) ->
    e.preventDefault()
    $this = $(this)
    addCategory(
      title: $this.text()
      branchId: $this.data('branchId')
    )
  )

  # return to parent category by click
  $currentCategories.on('click', 'a', (e) ->
    e.preventDefault()
    $this = $(this)
    returnToParentCategory($this.data('branchId'))
  )

  # set current category
  updateCategory = ->
    $currentCategories.html('')
    for category, i in categories 
      label = if i < categories.length - 1 then 'label-info' else 'label-warning'
      arrow = if i > 0 then '> ' else ''
      #$category = $("<li><a href=\"#\" data-branch-id=\"#{category.branchId}\">#{category.title}</a></li>")
      $category = $("<li>#{arrow}<a href=\"#\" data-branch-id=\"#{category.branchId}\"><span class=\"label #{label}\">#{category.title}</span></a></li>")
      $currentCategories.append($category)
    currentCategory = categories[categories.length - 1]
    #$categoryField.keyup()
    getSubCategories()
    $contentField.keyup()
    updateContent()

  addCategory = (category) ->
    categories.push(category) 
    updateCategory()

  returnToParentCategory = (branchId) ->
    index = -1
    for category, i in categories 
      if category.branchId == branchId
        index = i
        break
    
    console.log(branchId, index)
    if index > -1
      categories.splice(index + 1) 
      updateCategory()

  # count content
  $contentField.keyup ->
    count = 120 - $(this).val().length  
    $contentCount.text(count)
    if (count < 0)
      $contentCount.addClass('over')
    else
      $contentCount.removeClass('over')

  updateContent = ->
    console.log('test')
    $contentMessage.text('')
    $contentTitle.text(currentCategory.title) 
    $.get("/words/#{currentCategory.branchId}/contents?user_id=#{SESSION.id}", (data) ->
      if data
        console.log(data)
        $contentField.val(data[0].content)
    )

  # add category
  $categoryForm.submit (e) ->
    e.preventDefault()
    console.log('submit') 
    category = $categoryField.val()
    $categoryBranchId.val(currentCategory.branchId)
    if category
      $.ajax(
        type: 'post',
        url: "/words",
        data: $categoryForm.serialize(),
        success: (data) ->
          if data
            $categoryField.val('')
            addCategory(
              branchId: data.branch_id
              title: data.title
            )
      )
      

  # post word
  $contentForm.submit (e) ->
    e.preventDefault()
    content = $contentField.val()
    if content.length < 121
      $.ajax(
        type: 'post',
        url: "/words/#{currentCategory.branchId}",
        data: $contentForm.serialize(),
        success: (data) ->
          $contentMessage.text('本文を保存しました')
      )

  # init
  $('.js_user_name').text(USER.name)
  updateCategory()

