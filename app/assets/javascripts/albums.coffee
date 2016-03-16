jQuery ->
#  localStorage.removeItem 'onboarding'
  unless localStorage.getItem 'onboarding'
    $('body').addClass 'image-wall'
    cover = $('.cover')
    cover.fadeIn()

    cover.click ->
      localStorage.setItem 'onboarding', true
      $('body').removeClass 'image-wall'
      window.location.href = 'albums/new'

  dropZone = $('#drop-zone')
  container = $('.file-uploader')
  $(document).bind 'dragover', (e) ->
    e.preventDefault()
    container.addClass 'active'
    if (e.target == dropZone[0])
      container.addClass 'in'
      container.removeClass 'active'

  $(document).bind 'drop', (e) ->
    e.preventDefault()
    container.removeClass 'active'
    container.removeClass 'in'

  container.click ->
    window.location.href = 'albums/new'

  files = []
  $('#drop-input').fileupload
    dataType: 'json'
    dropZone: dropZone
    url: '/albums/quickupload'
    done: (e, data) ->
      console.log(data)
      if (data.result)
        files.push(data.result.pins[0])
    stop: ->
      window.location.href = 'albums/new?' + files.map((val) ->
        'pins[]=' + val).reduce (p, n) -> p + '&' +  n

