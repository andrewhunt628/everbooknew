class App.Album extends Spine.Controller
  elements:
    '#pins': 'pins'

  events:
    'click .remove-button': 'removePin'
    'blur #pin-title': 'submitTitle'
    'blur #pin-description': 'submitDescription'

  constructor: ->
    super

    @pins.imagesLoaded ->
      this.masonry
        itemSelector: '.box'

  id: (e) ->
    $(e.target).data 'id'

  removePin: (e) =>
    $.ajax
      url: '/pins/' + @id(e)
      type: 'DELETE'
    .done (result) ->
      window.location.href = '/albums/' + window.album
    .fail (error) ->
      window.location.href = '/albums/' + window.album

  submitTitle: (e) ->
    $.ajax
      url: '/pins/' + @id(e) + '.json'
      type: 'PATCH'
      data:
        pin:
          id: @id(e)
          title: e.target.value

  submitDescription: (e) ->
    $.ajax
      url: '/pins/' + @id(e) + '.json'
      type: 'PATCH'
      data:
        pin:
          id: @id(e)
          description: e.target.value