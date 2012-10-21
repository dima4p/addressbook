url = '<%= contact_path  @contact %>'
line = $("a[href='#{url}']").closest('tr')
line.replaceWith "<%= escape_javascript(render @contact) %>"
$('#onpage').overlay().close()
line = $("a[href='#{url}']").closest('tr')
$.fn.highlight line
