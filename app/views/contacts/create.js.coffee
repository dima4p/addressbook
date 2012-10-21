$('tbody').html "<%= escape_javascript(render @contacts) %>"
$('#onpage').overlay().close()
line = $('tr.new_record')
$.fn.highlight line
