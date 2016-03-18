class App.Album extends Spine.Controller
  events:
    'click #new-album': 'createNewAlbum'

  elements:
    '.new-album': 'newAlbum'
    '#new-album-flag': 'newAlbum?'
    '#pins': 'pins'

  constructor: ->
    super
    @newAlbum?.val false

    @pins.imagesLoaded =>
      @pins.masonry
        itemSelector: '.box'

  createNewAlbum: ->
    @newAlbum.toggleClass 'hidden'
    console.log @newAlbum?.val()