class App.Explore extends Spine.Controller
  elements:
    '.cover': 'cover'
    '#pins': 'pins'
    '#sign_in_count': 'sign_in_count'

  events:
    'click .cover': 'removeCover'
    'click #upload-button': 'removeCover'

  constructor: ->
    super
    if (sign_in_count.value == '1')  && !localStorage.getItem('showedCover')
      $('body').addClass 'image-wall'
      @cover.fadeIn()

    @pins.imagesLoaded =>
      @pins.masonry
        itemSelector: '.box'

  removeCover: ->
    localStorage.setItem 'showedCover', true
    window.location.href = '/uploader'
