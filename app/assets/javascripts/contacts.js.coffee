# Place all the behaviors and hooks related to the contacts controller here.

$ ->
  if $('#onpage').length
    $('#onpage').overlay
      load: false
      top: "center"
      mask:
        maskId: "overlay_mask"

  $.fn.resize_dialog = ->
    div = $('#onpage')
    top = (window.innerHeight - div.height()) / 2
    left = (window.innerWidth - div.width()) / 2
    div.css('left', left)
    div.css('top', top)

  $.fn.highlight = (line)->
    line.css 'background-color', '#f88'
    line.animate { backgroundColor: '#fff' },
      1000
      'linear'
      ->
        line.removeClass 'highlight'

  $(window).resize($.fn.resize_dialog)

  $(document).on 'click', 'body.contacts .onpage', ->
    $.getScript $(this).attr('href')
    false

  $(document).on 'click', 'body.contacts .ajax', ->
    form = $(this).closest('form')
    form.ajaxSubmit
      dataType: 'script'
    false

  true
