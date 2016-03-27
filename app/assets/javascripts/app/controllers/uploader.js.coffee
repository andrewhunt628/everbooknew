class App.Uploader extends Spine.Controller
  elements:
    '#drop-input': 'dropInput'
    '#drop-zone': 'dropZone'
    '.upload': 'container'
    '#upload-status': 'uploadStatus'

  events:
    'dragover': 'dragOver'
    'drop': 'drop'
    'click #chose-files': 'triggerUpload'
    'click .remove-button': 'removePin'
    'click #final': 'finalRedirect'

  initializeMasonry: ->
    @pins.masonry
      itemSelector: '.box'

  dragOver: (e) =>
    e.preventDefault()
    @container.addClass 'active'
    if (e.target == @dropZone[0])
      @container.addClass 'in'
      @container.removeClass 'active'

  triggerUpload: =>
    console.log @dropInput
    @dropInput.trigger 'click'

  removePin: (e) =>
    @removeId = $(e.target).data 'id'
    $.ajax({
        url: '/pins/' + @removeId
        type: 'DELETE'
    })
    .done (result) =>
      window.location.href = '/uploader?' + @toString @files.filter (pin) -> pin != @removeId
    .fail (error) =>
      window.location.href = '/uploader?' + @toString @files.filter (pin) -> pin != @removeId

  finalRedirect: ->
    window.location.href = '/uploader/finish?' + @toString @files

  drop: (e) =>
    e.preventDefault()
    @container.removeClass 'active'
    @container.removeClass 'in'

  toString: (pins) ->
    pins.map((val) -> 'pins[]=' + val).reduce (p, n) -> p + '&' + n

  constructor: ->
    super
    @files = window.files || []

    @dropInput.fileupload
      dataType: 'json'
      dropZone: @dropZone
      url: '/uploader'
      done: @uploadDone
      start: @uploadStart
      stop: @uploadStop
      progressall: @uploadProgress

  uploadDone: (e, data) =>
    @files.push(data.result.pins[0]) if data.result

  uploadStop: (e) =>
    window.location.href = '/uploader?' + @toString @files

  uploadStart: =>
    @uploadStatus.toggleClass('hidden')

  uploadProgress: (e, data) =>
    @progressBar = @uploadStatus.find('.progress-bar')
    value = parseInt(data.loaded / data.total * 100)
    @progressBar.attr('aria-valuenow', value)
    @progressBar.css('width', value + '%')
    @progressBar.find('span').text value + '%'
