class PinItem extends Spine.Controller
  className: 'col-xs-3 pin-container'
  events:
    'click .remove':  'markAsRemoveImg'
    'click .restore': 'restoreImg'

  constructor: ->
    super
    @initAndDisplayPin()

  initAndDisplayPin: ->
    if @pin.isUploaded()
      @html @view("pin_uploader/pin")(file: @pin.url)
    else
      reader = new FileReader()
      reader.onload = (e) =>
        if e.target.result.split(';')[0] == 'data:application/pdf'
          pin = "/#{@scope}/img/pdf_icon.png"
        else
          pin = e.target.result

        @html @view("pin_uploader/pin")(file: pin)

      reader.readAsDataURL(@pin.data.files[0])

  markAsRemoveImg: (e) ->
    e.preventDefault()
    @el.find(".thumbnail").addClass('was-deleted')
    @pin._destroy = true
    @pin.save()

  restoreImg: (e) ->
    e.preventDefault()
    @el.find(".thumbnail").removeClass('was-deleted')
    @pin._destroy = false
    @pin.save()

###########################
###########################

class App.PinUploadForm extends Spine.Controller
  @extend Spine.Events

  elements:
    '#preview': 'preview'
    '#progress_bar .progress-bar': 'progress_bar'

  constructor: ->
    super
    @whiteList = /(\.|\/)(pdf|gif|jpe?g|png)$/i
    @setupFileUploader()
    @amount_of_uploaded_files  = 0
    @renderExistingPins()

  renderExistingPins: ->
    for container in @el.find("[data-type=pin]")
      do (container) =>
        url = $(container).data('url')
        pin = App.Pin.create id: $(container).data('id'), kind: 'uploaded', url: url, _destroy: false

        thumb = new PinItem pin: pin, scope: @el.data('scope')
        @preview.append thumb.el


  setupFileUploader: ->
    @el.fileupload
                  dataType: 'json',
                  done: @done
                  add:  @add

  done: (e, data) =>
    App.Pin.create id: data.result.id, kind: 'uploaded', '_destroy': false
    @amount_of_uploaded_files += 1
    @trigger 'allFilesUploads' if @percent() == 100
    percent = "#{@percent()}%"
    console.log percent
    @progress_bar.width percent
    @progress_bar.html  percent
  
  percent: ->
    amount_of_files_to_upload = App.Pin.getPinsForUploading().length
    parseInt(@amount_of_uploaded_files/amount_of_files_to_upload * 100)

  add: (e, data) =>
    unless @whiteList.exec(data.files[0].name)
      window.displayNotices('Incorrect file format. Use only gif, jpeg, png') 
      return 

    pin = new App.Pin data: data, kind: 'for_uploading', '_destroy': false
    pin.save()

    thumb = new PinItem pin: pin, scope: @el.data('scope')
    @preview.append thumb.el

  submit: (pin_ids) ->
    if App.Pin.getPinsForUploading().length == 0
      @trigger 'allFilesUploads' 
    else
      @el.find("#progress_bar").removeClass('hide')
      for pin in App.Pin.getPinsForUploading()
        pin.data.submit()

##############################
##############################
