class App.Album extends Spine.Controller
  elements:
    '#pins': 'pins'

  events:
    'click .remove-button': 'removePin'

  constructor: ->
    super

    @pins.imagesLoaded ->
      this.masonry
        itemSelector: '.box'

  removePin: (e) ->
    $.ajax
      url: '/pins/' + $(e.target).data 'id'
      type: 'DELETE'
    .done (result) ->
      window.location.href = '/albums/' + window.album
    .fail (error) ->
      window.location.href = '/albums/' + window.album
