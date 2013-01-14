# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  if !$.cookie('closed_iphone_link') 
    $('.js-iphone-link').show() 


  $('.js-iphone-link').bind('closed', ->
    $.cookie('closed_iphone_link', 1) 
  )
