class App.Pin extends Spine.Model
  #FIXME it sould be without ajax
  #use for storing images in albome form
  @configure 'Pin', 'id', 'kind', 'url', 'data', '_destroy'

  @getPinsForDestroy: ->
    @select (pin) ->
      pin._destroy == true and pin.kind == 'uploaded'
    
  @getPinsForAdding: ->
    @select (pin) ->
      pin._destroy == false and pin.kind == 'uploaded'

  @getPinsForUploading: ->
    @select (pin) ->
      pin._destroy == false and pin.kind == 'for_uploading'

  isUploaded: ->
    @kind == 'uploaded'
