class App.Explore extends Spine.Controller
  elements:
    '.cover': 'cover'
    '#pins': 'pins'

  events:
    'click .cover': 'removeCover'
    'click #upload-button': 'removeCover'

  constructor: ->
    super
    unless localStorage.getItem 'onboarding'
      $('body').addClass 'image-wall'
      @cover.fadeIn()

    @pins.imagesLoaded =>
      @pins.masonry
        itemSelector: '.box'

  removeCover: ->
    localStorage.setItem 'onboarding', true
    window.location.href = '/uploader'
