class App.UploaderFinish extends Spine.Controller
  events:
    'click #finish': 'complete'
    'click .remove-button': 'removePin'
    'click .back': 'goBack'
    'keyup #global-title': 'updateTitle'
    'focus #global-title': 'clearTitlePlaceholder'
    'blur #global-title': 'resetTitlePlaceholder'
    'keyup #global-description': 'updateDescription'
    'focus #global-description': 'clearDescriptionPlaceholder'
    'blur #global-description': 'resetDescriptionPlaceholder'

  elements:
    '#pins': 'pins'

  constructor: ->
    super

    @files = window.files || []

    @pins.imagesLoaded =>
      @pins.masonry
        itemSelector: '.box'

  complete: ->
    $('.pin-form').submit()

  toString: (pins) ->
    return '' unless pins.length
    pins.map((val) -> 'pins[]=' + val).reduce (p, n) -> p + '&' + n

  removePin: (e) =>
    @removeId = $(e.target).data 'id'
    $.ajax
      url: '/pins/' + @removeId
      type: 'DELETE'
    .done (result) =>
      window.location.href = '/uploader/finish?' + @toString @files.filter (pin) -> pin != @removeId
    .fail (error) =>
      window.location.href = '/uploader/finish?' + @toString @files.filter (pin) -> pin != @removeId

  goBack: =>
    window.location.href = '/uploader?' + @toString @files

  updateTitle: (e) =>
    $('.panel-pin .title').each (i, input) ->
      input.value = e.target.value

  clearTitlePlaceholder: (e) =>
    $('.panel-pin .title').each (i, input) ->
      input.placeholder = ''

  resetTitlePlaceholder: (e) =>
    $('.panel-pin .title').each (i, input) ->
      unless input.value
        input.placeholder = 'Title'

  updateDescription: (e) =>
    $('.panel-pin .description').each (i, input) ->
      input.value = e.target.value

  clearDescriptionPlaceholder: (e) =>
    $('.panel-pin .description').each (i, input) ->
      input.placeholder = ''

  resetDescriptionPlaceholder: (e) =>
    $('.panel-pin .description').each (i, input) ->
      unless input.value
        input.placeholder = 'Description'

