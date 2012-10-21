$('#onpage .content').html "<%= escape_javascript(render :partial => 'form') %>"
$('#onpage').overlay().load()
$.fn.resize_dialog()
$('#onpage form input[type="submit"]').addClass 'ajax'
