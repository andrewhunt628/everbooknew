class App.Albums extends Spine.Controller
  elements:
    '#pins': 'pins'
    '#drop-input': 'dropInput'
    '#drop-zone': 'dropZone'
    'body': 'body'
    'document': 'document'
    '.cover': 'cover'
    '.file-uploader': 'container'

  events:
    'imagesLoaded #pins': 'initializeMasonry'
    'dragover': 'dragOver'
    'drop': 'drop'
    'click #drop-zone': 'triggerUpload'
    'click .cover': 'removeOnboarding'

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
      done: @done
      stop: @stop

    unless localStorage.getItem 'onboarding'
      @removeOnboarding()

  done: (e, data) =>
    @files.push(data.result.pins[0]) if data.result

  stop: (e) =>
    localStorage.setItem 'onboarding', true
    window.location.href = '/albums/new?' + @files.map((val) -> 'pins[]=' + val).reduce (p, n) -> p + '&' + n

  removeOnboarding: ->
    $('body').addClass 'image-wall'
    @cover.fadeIn()

    @cover.click =>
      localStorage.setItem 'onboarding', true
      @triggerUpload()

