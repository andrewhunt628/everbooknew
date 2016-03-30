class App.Album extends Spine.Controller
  elements:
    '#pins': 'pins'

  events:
    'click .remove-button': 'removePin'
    'blur #pin-title': 'submitTitle'
    'blur #pin-description': 'submitDescription'
    'blur #tags': 'submitTags'
    'keyup #pin-title': 'submitByEnter'
    'keyup #pin-description': 'submitByEnter'
    'keyup #tags': 'submitByEnter'

  constructor: ->
    super

    @pins.imagesLoaded ->
      this.masonry
        itemSelector: '.box'

  id: (e) ->
    $(e.target).data 'id'

  removePin: (e) =>
    $.ajax
      url: '/pins/' + @id e
      type: 'DELETE'
    .done (result) ->
      window.location.href = '/albums/' + window.album
    .fail (error) ->
      window.location.href = '/albums/' + window.album

  submitTitle: (e) ->
    @updatePin @id(e), {title: e.target.value}

  submitDescription: (e) ->
    @updatePin @id(e), {description: e.target.value}

  submitTags: (e) ->
    @updatePin @id(e), {tag_list: e.target.value}

  submitByEnter: (e) ->
    if (e.keyCode == 13)
      $(e.target).blur()

  updatePin: (id, data) ->
    sendObj = {
      id: id
    }
    $.extend sendObj, data
    $.ajax
      url: '/pins/' + id + '.json'
      type: 'PATCH'
      data:
        pin: sendObj

  removeTag: (e) ->
    $.ajax
      url: '/pins/' + $(e.target).data('pin-id') + '/tags/' + $(e.target).data('tag-id') + '.json'
      type: 'DELETE'
    .done (result) ->
      $(e.target).parent().remove()
    .fail (error) ->
      $(e.target).parent().remove()

