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
    'click .hash-tag .delete': 'deleteHashTag'
    'click .pin-hash-tag .delete-local': 'deleteLocalHashTag'
    'keyup #add-hashtag': 'addHashTag'
    'click #new-album': 'createNewAlbum'
    'click .back-to-top': 'scrollTop'

  elements:
    '#pins': 'pins'

  constructor: ->
    super

    @files = window.files || []

    @pins.imagesLoaded =>
      @initMasonry()

  initMasonry: =>
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

  scrollTop: ->
    $(window).scrollTop(0)

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

  deleteHashTag: (e) =>
    $(e.target.parentNode).remove()

    @replaceHashTags()

    @initMasonry()

  deleteLocalHashTag: (e) =>
    $(e.target.parentNode).remove()
    @initMasonry()

  replaceHashTags: =>
    $('.panel-pin .tags-group').html ''
    $('#global-hashtags').find('.hash-tag').each (i, tagNode) =>
      $('.panel-pin .tags-group').each (i, element) =>
        $(element).append '<span class="pin-hash-tag">' + $(tagNode).contents()[0].textContent + '<span class="delete-local">×</span></span>'

  addHashTag: (e) =>
    if (e.keyCode == 13)
      $('#global-hashtags').prepend '<span class="hash-tag">' + e.target.value + ' <span class="delete">×</span></span>'
      @replaceHashTags()
      e.target.value = ''
      @initMasonry()
    e.preventDefault()

  createNewAlbum: =>
    $('#new-album-form').toggleClass 'hidden'
    $('#new-album-flag').val $('#new-album-flag').val() == 'false' ? true : false
    @initMasonry()

