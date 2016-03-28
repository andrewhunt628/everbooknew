class App.Albums extends Spine.Controller
  elements:
    '.edit-album a': 'editAlbumLink'

  events:
    'click .edit-album a': 'editAlbum'

  constructor: ->
    super

    @toggled = false

  editAlbum: (e) ->
    e.preventDefault()
    id = $(e.target).data 'id'
    title = $(e.target).parent().parent().find('.media-heading')
    description = $(e.target).parent().parent().find('.media-middle')
    unless @toggled
      title.attr 'contenteditable', true
      description.attr 'contenteditable', true
      title.toggleClass 'editing'
      description.toggleClass 'editing'
      $(e.target).text 'Done'
      @toggled = true
    else #save state
      $(e.target).text 'Edit Album'
      @toggled = false
      title.toggleClass 'editing'
      description.toggleClass 'editing'
      $.ajax
        url: '/albums/' + id + '.json'
        type: 'PATCH'
        data:
          album:
            id: id
            title: title.text()
            description: description.text()
        success: ->
          title.attr 'contenteditable', false
          description.attr 'contenteditable', false
        fail: ->
          title.attr 'contenteditable', false
          description.attr 'contenteditable', false

