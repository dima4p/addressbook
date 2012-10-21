url = '<%= contact_path  @contact %>'
line = $("a[href='#{url}']").closest('tr')
line.fadeOut 1000, ->
  line.remove()
