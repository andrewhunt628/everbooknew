class App.Picture extends Spine.Model
  #FIXME it sould be without ajax
  #use for storing images in albome form
  @configure 'Picture', 'id', 'kind', 'url', 'data', '_destroy'

  @getPicturesForDestroy: ->
    @select (picture) ->
      picture._destroy == true and picture.kind == 'uploaded'
    
  @getPicturesForAdding: ->
    @select (picture) ->
      picture._destroy == false and picture.kind == 'uploaded'

  @getPicturesForUploading: ->
    @select (picture) ->
      picture._destroy == false and picture.kind == 'for_uploading'

  isUploaded: ->
    @kind == 'uploaded'
