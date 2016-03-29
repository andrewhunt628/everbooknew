class App.UploaderFinish extends Spine.Controller
  events:
    'click #finish': 'complete'
    'click .remove-button': 'removePin'
    'click .back': 'goBack'
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

  deleteHashTag: (e) =>
    $(e.target.parentNode).remove()

    @initMasonry()

  deleteLocalHashTag: (e) =>
    $(e.target.parentNode).remove()
    @initMasonry()

  addHashTag: (e) =>
    if (e.keyCode == 13)
      $('#global-hashtags').prepend '<span class="hash-tag">' + e.target.value + ' <span class="delete">×</span></span>'
      e.target.value = ''
      @initMasonry()
    e.preventDefault()

  createNewAlbum: =>
    $('#new-album-form').toggleClass 'hidden'
    $('#new-album-flag').val $('#new-album-flag').val() == 'false' ? true : false
    @initMasonry()

