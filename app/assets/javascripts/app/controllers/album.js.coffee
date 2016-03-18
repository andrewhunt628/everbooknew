class App.Album extends Spine.Controller
  events:
    'click #new-album': 'createNewAlbum'

  elements:
    '.new-album': 'newAlbum'
    '#new-album-flag': 'newAlbum?'
    '#pins': 'pins'

  constructor: ->
    super

    @pins.imagesLoaded =>
      @pins.masonry
        itemSelector: '.box'

  createNewAlbum: ->
    @newAlbum.toggleClass 'hidden'
    $('#new-album-flag').val $('#new-album-flag').val() == "false" ? true : false
