class App.Albums extends Spine.Controller
  elements:
    '#pins': 'pins'
    '#drop-input': 'dropInput'
    '#drop-zone': 'dropZone'
    'body': 'body'
    'document': 'document'
    '.cover': 'cover'
    '.file-uploader': 'container'
    '#upload-status': 'uploadStatus'

  events:
    'imagesLoaded #pins': 'initializeMasonry'
    'dragover': 'dragOver'
    'drop': 'drop'
    'click #drop-zone': 'triggerUpload'
    'click .cover': 'removeCover'

  initializeMasonry: ->
    @pins.masonry
      itemSelector: '.box'

  dragOver: (e) ->
    e.preventDefault()
    @container.addClass 'active'
    if (e.target == @dropZone[0])
      @container.addClass 'in'
      @container.removeClass 'active'

  triggerUpload: ->
    @dropInput.trigger 'click'

  drop: (e) ->
    e.preventDefault()
    @container.removeClass 'active'
    @container.removeClass 'in'

  constructor: ->
    super
    @files = []

    @pins.imagesLoaded =>
      @pins.masonry
        itemSelector: '.box'

    @dropInput.fileupload
      dataType: 'json'
      dropZone: @dropZone
      url: '/albums/quickupload'
      done: @uploadDone
      start: @uploadStart
      stop: @uploadStop
      progressall: @uploadProgress

    unless localStorage.getItem 'onboarding'
      @initializeOnboarding()

  uploadDone: (e, data) =>
    @files.push(data.result.pins[0]) if data.result

  uploadStop: (e) =>
    localStorage.setItem 'onboarding', true
    window.location.href = '/albums/new?' + @files.map((val) -> 'pins[]=' + val).reduce (p, n) -> p + '&' + n

  uploadStart: =>
    @uploadStatus.toggleClass('hidden')
    @removeOnboarding()

  uploadProgress: (e, data) =>
    @progressBar = @uploadStatus.find('.progress-bar')
    value = parseInt(data.loaded / data.total * 100)
    @progressBar.attr('aria-valuenow', value)
    @progressBar.css('width', value + '%')
    @progressBar.find('span').text value + '%'

  initializeOnboarding: =>
    $('body').addClass 'image-wall'
    @cover.fadeIn()

  removeCover: =>
    @removeOnboarding()
    @triggerUpload()

  removeOnboarding: =>
    localStorage.setItem 'onboarding', true
    @cover.fadeOut 400, ->
      $('body').removeClass 'image-wall'

