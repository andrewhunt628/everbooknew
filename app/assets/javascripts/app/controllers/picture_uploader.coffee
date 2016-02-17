class PictureItem extends Spine.Controller
  className: 'col-xs-3 image-container'
  events:
    'click .remove':  'markAsRemoveImg'
    'click .restore': 'restoreImg'

  constructor: ->
    super
    @initAndDisplayPicture()

  initAndDisplayPicture: ->
    if @picture.isUploaded()
      @html @view("picture_uploader/picture")(file: @picture.url)
    else
      reader = new FileReader()
      reader.onload = (e) =>
        if e.target.result.split(';')[0] == 'data:application/pdf'
          image = "/#{@scope}/img/pdf_icon.png"
        else
          image = e.target.result

        @html @view("picture_uploader/picture")(file: image)

      reader.readAsDataURL(@picture.data.files[0])

  markAsRemoveImg: (e) ->
    e.preventDefault()
    @el.find(".thumbnail").addClass('was-deleted')
    @picture._destroy = true
    @picture.save()

  restoreImg: (e) ->
    e.preventDefault()
    @el.find(".thumbnail").removeClass('was-deleted')
    @picture._destroy = false
    @picture.save()

###########################
###########################

class App.PictureUploadForm extends Spine.Controller
  @extend Spine.Events

  elements:
    '#preview': 'preview'
    '#progress_bar .progress-bar': 'progress_bar'

  constructor: ->
    super
    @whiteList = /(\.|\/)(pdf|gif|jpe?g|png)$/i
    @setupFileUploader()
    @amount_of_uploaded_files  = 0
    @renderExistingPictures()

  renderExistingPictures: ->
    for container in @el.find("[data-type=picture]")
      do (container) =>
        if $(container).data('content_type') == 'application/pdf'
          url = "/#{@el.data('scope')}/img/pdf_icon.png"
        else
          url = $(container).data('url')
        picture = App.Picture.create id: $(container).data('id'), kind: 'uploaded', url: url, _destroy: false

        thumb = new PictureItem picture: picture, scope: @el.data('scope')
        @preview.append thumb.el


  setupFileUploader: ->
    @el.fileupload
                  dataType: 'json',
                  done: @done
                  add:  @add

  done: (e, data) =>
    App.Picture.create id: data.result.id, kind: 'uploaded', '_destroy': false
    @amount_of_uploaded_files += 1
    @trigger 'allFilesUploads' if @percent() == 100
    percent = "#{@percent()}%"
    @progress_bar.width percent
    @progress_bar.html  percent
  
  percent: ->
    amount_of_files_to_upload = App.Picture.getPicturesForUploading().length
    parseInt(@amount_of_uploaded_files/amount_of_files_to_upload * 100)

  add: (e, data) =>
    unless @whiteList.exec(data.files[0].name)
      window.displayNotices('Incorrect file format. Use only gif, jpeg, png') 
      return 

    picture = new App.Picture data: data, kind: 'for_uploading', '_destroy': false
    picture.save()

    thumb = new PictureItem picture: picture, scope: @el.data('scope')
    @preview.append thumb.el

  submit: (picture_ids) ->
    if App.Picture.getPicturesForUploading().length == 0
      @trigger 'allFilesUploads' 
    else
      @el.find("#progress_bar").removeClass('hide')

      for picture in App.Picture.getPicturesForUploading()
        picture.data.submit()

##############################
##############################
