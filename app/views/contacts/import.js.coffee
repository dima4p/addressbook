$('#onpage .content').html "<%= escape_javascript(render :partial => 'import') %>"
$('#onpage').overlay().load()
$.fn.resize_dialog()
$('#onpage form input[type="submit"]').addClass 'ajax'
