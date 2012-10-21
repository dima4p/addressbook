form = $ 'form'
form.replaceWith "<%= escape_javascript(render partial: 'form') %>"
$('#onpage form input[type="submit"]').addClass 'ajax'
