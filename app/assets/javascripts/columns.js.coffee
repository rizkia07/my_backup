# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if !window.console
  window.console = {
    log: ->
    info: ->
    error: ->
    debug: ->
  }

$(->
  return if !$('#columns').length

  console.info('[start] init columns')

  # constants
  ROOT =
    branchId: 2 
    title: 'Baton'
  LANG_ID = 2
  LOCALE = 'ja'

  # vars
  currentWord = ROOT

  movingWord = null

 
  # jquery caches
  $title = $('.js_title')
  $columns = $('.js_columns')
  $wrapper = $('.js_columns_wrapper')

  # 
  # functions 
  # 

  # create word element
  buildChild = (child) ->
    aHref = if child.url_name then child.title else '#'
    aText = if child.url_name then child.url_name else child.title
    aText = aText.slice(0, 8) + '...' if aText.length > 8
    aClass = if child.url_name then 'link' else 'word'
    aTarget = if child.url_name then '_blank' else ''
    liClass = if child.is_leaf then 'checked' else ''

    wikipediaLink = """ 
                <a href="http://ja.wikipedia.org/wiki/#{encodeURIComponent(child.title)}" target="_blank"><i class="icon-book"></i></a>
    """
    wikipediaLink = "" if child.url_name 

    return """
            <li class="cell js_cell #{liClass}" data-branch-id="#{child.branch_id}">
              <a href="#" class="check">
                <img src="/assets/columns/check#{ if child.is_leaf then '_on' else '' }.png">
              </a>
              <a href="#{aHref}" class="#{aClass}" target="#{aTarget}" title="#{child.title}">
                #{aText} (#{child.leaf_num})
              </a>
              <!--a href="#" class="more js_more"><i class="icon-chevron-down"></i></a-->
              <div class="buttons js_buttons">
                #{wikipediaLink}
                <a href="https://www.google.co.jp/search?q=#{encodeURIComponent(child.title)}" target="_blank"><i class="icon-search"></i></a>
                <a href="#" class="js_move"><i class="icon-move"></i></a>
                <a href="#" class="js_remove"><i class="icon-trash"></i></a>
                <a href="https://baton.mindia.jp/#{child.branch_id}" target="_brank"><i class="icon-share"></i></a>
              </div>
            </li>
          """
  # get children of current word
  fetchChildren = (prepend = false, cb) ->
    column = ["<div class=\"span3 js_column column\" data-branch-id=\"#{currentWord.branchId}\">", '<ul>']

    $.get("/words/#{currentWord.branchId}.json?user_id=#{SESSION.id}", (data) ->
      if data && data.children

        column.push("""
          <li class="header">
            #{currentWord.title || data.breadcrumbs[0].title}
          </li>
        """)

        for child in data.children
          column.push(buildChild(child))

        column.push("""
          <li class="add">
            <form class="form-inline js_add_form">
              <div class="input-append">
                <input type="text" name="words[title]" class="input-medium js_add_field" placeholder="Title"
                ><button type="submit" class="btn">＋</button>
              </div>
              <input type="hidden" name="words[user_id]" value="#{SESSION.id}" />
              <input type="hidden" name="words[parent_id]" class="js_category_branch_id" value="#{currentWord.branchId}" />
            </form>
          </li>
          <li class="put js_put">
            <a href="#" class="btn"><i class="icon-download-alt"></i>ここに移動</a>
          </li>
        """)

        column.push('</ul>', '</div>')

        if !prepend
          $columns.append(column.join(''))
          fetchContents($('.js_column:last ul'))
        else
          $columns.prepend(column.join(''))
          #$columns.find('.js_column:last').before(column.join(''))

          fetchContents($('.js_column:first ul'))
          updateWidth($('.js_column').length)
          $wrapper.scrollLeft(0)
          cb(null)

      console.log(data.breadcrumbs.length, $('.js_column').length)
      if !prepend && data.breadcrumbs && data.breadcrumbs.length >= $('.js_column').length && !$('.js_search_column').length
        parents = data.breadcrumbs.slice(1)
        parents.push(
          branch_id: ROOT.branchId
          title: ROOT.title
        )
        console.log(parents)
        async.forEachSeries(parents, (parent, cb) ->
          currentWord = 
            branchId: parent.branch_id
            title: parent.title 
          fetchChildren(true, cb)
        , (err) ->
          updateTitle()
        )
    )

  # get contents of word
  fetchContents = ($ul) ->
    return if currentWord.branchId < 100

    $.get("/words/#{currentWord.branchId}/contents.json?user_id=#{SESSION.id}", (data) ->
      console.log(data)

      contents = ['<ul>', '<li class="contents js_contents">', '<ul>']

      for d in data

        isCurrent = ''
        editArea = ''
        if d == data[0]
          editArea = """
            <form class="edit_form js_edit_form">
              <textarea name="words[content]" class="content js_content" placeholder="#{localize('Please write!')}">#{d.content}</textarea>
              <button type="submit" class="btn js_btn btn-mini" disabled><i class="icon-ok"></i></button>
              <input type="hidden" name="_method" value="put" />
              <input type="hidden" name="words[user_id]" value="#{SESSION.id}" />
              <span class="count js_count">#{120 - d.content.length}</span>
            </form>
          """
          if data.length < 2
            isCurrent = ' current'

        if d == data[1] && data.length > 1
          isCurrent = ' current'

        content = if d.content then d.content else localize('Please write!')
        contents.push("""
          <li class="content js_content#{isCurrent}">#{editArea || content}</li>
        """)

      contents.push('</ul>')
      contents.push("""
        <div class="buttons js_buttons">
          <a href="#" class="arrow left js_contents_left"><i class="icon-circle-arrow-left"></i></a>
          <a href="#" class="arrow right js_contents_right"><i class="icon-circle-arrow-right"></i></a>
      """)

      for d in data
        isCurrent = ''
        if d == data[1] && data.length > 1
          isCurrent = ' current'
        else if d == data[0] && data.length < 2
          isCurrent = ' current'

        iconClass = if d.is_fav then 'icon-star' else 'icon-star-empty'
        linkClass = 'js_fav_link'
        linkHref = '#'

        if d == data[0]
          iconClass = 'icon-star'
          linkClass = ''
          linkHref = ''

        contents.push("""
          <div class="fav js_fav#{isCurrent}" data-leaf-id="#{d.leaf_id}">
            <a href="#{linkHref}" class="#{linkClass}"><i class="#{iconClass}"></i></a>
            <span class="fav_label js_fav_label">#{d.fav_num}</span>
          </div>
        """)

      contents.push("""
        </div>
      """)
      contents.push('</ul>')
      $ul.find('li:eq(0)').after(contents.join(''))

      $ul.on('click', '.js_contents .js_buttons a', slideContents)
      
    )

  # explore contents
  slideContents = (e) ->
    e.preventDefault()
    $this = $(this)
    dir = if $this.hasClass('js_contents_left') then -1 else 1

    $ul = $this.parent('.js_buttons').prev()
    console.log($ul)

    $contents = $ul.find('li.js_content')
    $favs = $this.parent('.js_buttons').find('.js_fav')
    console.log($favs.find('.current'))
    $favs.filter('.current').removeClass('current')

    index = $contents.index($ul.find('li.js_content.current').removeClass('current'))
    index += dir
    console.log(index)

    index = $contents.length - 1 if index < 0
    index = 0 if index >= $contents.length

    console.log($contents, index)
    $contents.eq(index).addClass('current')
    $favs.eq(index).addClass('current')
 
  updateTitle = ->
    #$title.text(currentWord.title)
    titles = []
    #$('li.js_cell.current a.word').each(->
    $('li.header').each(->
      #titles.push($(this).attr('title').trim().replace(/\([0-9]+\)$/, '')) 
      titles.push($(this).text().trim()) 
    )
    $title.text(titles.join(' > '))
    if $title.text().length > 50
      $title.text('...' + $title.text().slice(-50))

    if movingWord
      $title.text(movingWord.title.slice(-50) + "を移動");
      $columns.addClass('moving')
    else
      $columns.removeClass('moving')


  updateWidth = (count) ->
    w = $('.js_column:eq(0)').width()
    $columns.width(w * count)
    
    $wrapper.scrollLeft($columns.width() - $wrapper.width())

    $wrapper.height($(window).height() - 50)
    #$wrapper.height((document.documentElement.clientHeight || document.body.clientHeight || document.body.scrollHeight) - 50)

  updateCheck = ($img, isCheck) ->
    if isCheck
      $img.attr('src', $img.attr('src').replace(/check(_on)?/, 'check_on'))
      $img.parents('li').addClass('checked')
    else
      $img.attr('src', $img.attr('src').replace(/_on/, ''))
      $img.parents('li').removeClass('checked')

  updateFav = ($favIcon, isFav) ->
    $favLabel = $favIcon.parents('.fav').find('.js_fav_label')
    if isFav
      $favIcon.removeClass('icon-star-empty')
      $favIcon.addClass('icon-star')
      $favLabel.text(parseInt($favLabel.text()) + 1)
    else
      $favIcon.removeClass('icon-star')
      $favIcon.addClass('icon-star-empty')
      $favLabel.text(parseInt($favLabel.text()) - 1)

  # 
  # Event handlers
  # 

  # select word
  selectWord = (e) ->
    e.preventDefault()
    $this = $(this)

    console.log($this)

    branchId = $this.parents('.js_cell').data('branchId')

    console.log(branchId, currentWord.branchId)
    return if branchId == currentWord.branchId

    currentWord =
      branchId: branchId
      title: $this.attr('title')
    location.hash = "w=#{branchId}"

    # remove right rows
    $column = $this.parents('.js_column') 
    $column.nextAll().remove()

    $column.find('.js_cell.current').removeClass('current')
    $this.parent('li').addClass('current')

    updateWidth($('.js_column').length + 1)

    fetchChildren()
    updateTitle()

    $img = $this.prev('.check').find('img')
    if $img.length
      updateCheck($img, true)

  $columns.on('click', 'a.word', selectWord)
  $columns.on('click', '.js_search_column .js_cell > *', selectWord)

  # check word
  $columns.on('click', 'a.check', (e) ->

    e.preventDefault()
    $this = $(this)
    $img = $this.find('img')

    newStatus = !/_on/.test($img.attr('src'))
    updateCheck($img, newStatus)

    $.ajax(
      type: 'post',
      url: "/words/#{$this.parents('.js_cell').data('branchId')}.json",
      data: {
        _method: 'put',
        words: {
          user_id: SESSION.id,
          is_leaf: newStatus,
        }
      },
      success: (data) ->
        console.log(data)
    )
  )

  # check word
  $columns.on('click', 'a.js_fav_link', (e) ->
    e.preventDefault()
    $this = $(this)
    $fav = $this.parents('.fav')
    $favIcon = $this.find('i')

    newStatus = !$favIcon.hasClass('icon-star')
    updateFav($favIcon, newStatus)

    $.ajax(
      type: 'post',
      url: " /leafs/#{$fav.data('leafId')}/favs.json",
      data: {
        _method: (if newStatus then 'post' else 'delete'),
        favs: {
          user_id: SESSION.id,
        }
      },
      success: (data) ->
        console.log(data)
    )
  )

  # add word
  $columns.on('submit', '.js_add_form', (e) ->
    e.preventDefault()
    $this = $(this)

    if !$this.find('.js_add_field').val()
      alert(localize('Please input title'))
      return

    $.ajax(
      type: 'post',
      url: "/words",
      data: $this.serialize(),
      success: (data) ->
        console.log(data)
        data.leaf_num = 0
        $this.parents('li').before(buildChild(data))
        $this.find('.js_add_field').val('')
        #$this.parents('.js_column').prev().find('li.current a.word').click()
    )
  )

  # search word
  $(document).on('submit', '.js_search_form', (e) ->
    e.preventDefault()
    $this = $(this)

    q = $this.find('.js_search_field').val()
    console.log('query', q)
    if !q
      return

    $.ajax(
      type: 'get',
      url: "/titles/#{q}.json?user_id=#{SESSION.id}&lang_id=#{LANG_ID}",
      success: (data) ->
        console.log(data)

        if data && data.length > 0
          # remove right rows
          $columns.find('.js_column:gt(0)').remove()
          $wrapper.scrollLeft(0)

          column = ["<div class=\"span3 js_column column js_search_column search_column\">", '<ul>']

          column.push("""
            <li class="header">
              #{localize('Search Result')}
            </li>
          """)

          for d in data
            console.log(d)

            parents = []
            for b in d.breadcrumbs
              parents.push(b.title)

            parents.splice(-1)

            column.push("""
              <li class="cell js_cell" data-branch-id="#{d.branch_id}">
                <div class="title">#{d.title}</div>
                <div class="parents">#{parents.join(' > ')}</div>
              </li>
            """)  

          column.push('</ul>', '</div>')

          $columns.append(column.join(''))
    )
  )


  # edit content
  $columns.on('focus', '.js_edit_form .js_content', (e) ->
    $(this).nextAll('.js_btn').prop('disabled', false)
    $(this).parents('.js_edit_form').find('.js_count').addClass('focus')
  )

  $columns.on('blur', '.js_edit_form .js_content', (e) ->
  #  $(this).nextAll('.js_btn').prop('disabled', true)
    $(this).parents('.js_edit_form').find('.js_count').removeClass('focus')
  )

  $columns.on('keyup', '.js_edit_form .js_content', (e) ->
    $this = $(this)
    length = $this.val().length
    $form = $this.parents('.js_edit_form')
    $form.find('.js_count').text(120 - length)
    if length > 120
      $form.addClass('over')
    else
      $form.removeClass('over')
  )

  $columns.on('submit', '.js_edit_form', (e) ->
    e.preventDefault()
    $this = $(this)
  
    branchId = $this.parents('.js_column').data('branchId')
    console.log(branchId)

    content = $this.find('.js_content').val()

    if content.length < 121
      $.ajax(
        type: 'post',
        url: "/words/#{branchId}",
        data: $this.serialize(),
        success: (data) ->
          console.log(data)
          $this.find('.js_btn').prop('disabled', true)
      )
  )

  $columns.on('click', '.js_more', (e) ->
    e.preventDefault()
    $this = $(this)

    $this.parents('.js_cell').toggleClass('more')

    $this.find('i').toggleClass('icon-chevron-down').toggleClass('icon-chevron-up')
  )
  
  $columns.on('click', '.js_move', (e) ->
    e.preventDefault()
    $this = $(this)

    movingWord =
      branchId: $this.parents('.js_cell').data('branchId')
      title: $this.parents('.js_cell').find('.word, .link').text().trim().replace(/\s\([0-9]+\)$/, '')
      before: $this.parents('.js_cell')

    updateTitle()
  )
 
  $columns.on('click', '.js_remove', (e) ->
    e.preventDefault()
    $this = $(this)

    return if !confirm(localize('Delete this word?')) 

    $cell = $this.parents('.js_cell')

    $.ajax(
      type: 'post',
      url: " /reports.json",
      data: {
        _method: 'post',
        reports: {
          user_id: SESSION.id,
          branch_id: $cell.data('branchId')
        }
      },
      success: (data) ->
        console.log(data)
        $cell.fadeOut(200)
    )

  )
 

  $(window).on('resize', ->
    updateWidth($('.js_column').length)
  )

  # move word
  $columns.on('click', '.js_put a', (e) ->
    e.preventDefault()
    $this = $(this)

    if movingWord.branchId

      movingWord.before.fadeOut(200)

      $.ajax(
        type: 'post',
        url: "/words/#{movingWord.branchId}.json",
        data: {
          _method: 'put',
          words: {
            user_id: SESSION.id,
            parent_id: $this.parents('.js_column').data('branchId') 
          }
        },
        success: (data) ->
          console.log(data)
          currentWord = {}
          $this.parents('.js_column').prev().find('li.current a.word').click()
          movingWord = null
          updateTitle()
      )

    else
      $this.parents('.js_column').find('.js_add_field').val(movingWord.title)
      $this.parents('.js_column').find('.js_add_form').submit()
      movingWord = null
      updateTitle()
  )

  scrollIntervalId = null;
  scrollDir = 0;
  $('.scroll').mouseover(->
    $this = $(this)
    console.log($this)
    scrollDir = if $this.hasClass('scroll_left') then -10 else 10 
    scrollIntervalId = setInterval(->
      $wrapper.scrollLeft($wrapper.scrollLeft() + scrollDir)      
    , 20);
  ).mouseout(->
    $this = $(this)
    console.log($this)
    clearInterval(scrollIntervalId);
  )

  # utils
  messages = 
    ja:
      'Please write!': '本文を120字以内で記入できます'
      'Please input title': 'タイトルを記入してください'
      'Delete this word?': 'この言葉を削除しますか？'
      'Search Result': '検索結果'

  localize = (message) ->
    if messages[LOCALE] && messages[LOCALE][message]
      return messages[LOCALE][message]
    else
      return message

  # indicator 
  spinner = new Spinner()
  console.log(spinner)
  $.ajaxSetup(
    beforeSend: ->
      spinner.stop()
      spinner.spin(document.body)
    complete: ->
      spinner.stop()
  )

  # init
  console.info('[end] init columns')

  search = location.search
  hash = location.hash

  if search
    search = search.slice(1)
    queries = search.split('&')

    for q in queries 
      if /add=/.test(q)
        title = decodeURIComponent(q.split('=')[1])
        if (title)
          movingWord =
            title: $('<div>').text(title).html()
          updateTitle()
        break
      else if /show=/.test(q)
        branchId = decodeURIComponent(q.split('=')[1])
        if (branchId)
          console.log(branchId)
          currentWord = 
            branchId: branchId
            title: ''
        break

  if hash 
    hash = hash.slice(1)
    queries = hash.split('&')
    console.log(hash)

    for q in queries 
      if /w=/.test(q)
        branchId = decodeURIComponent(q.split('=')[1])
        if (branchId)
          console.log(branchId)
          currentWord = 
            branchId: branchId
            title: ''
        break


  updateTitle()
  fetchChildren()
  $(window).resize()

)
