class AlbumFieldsForm extends Spine.Controller
  constructor: ->
    super
    new App.FormValidator el: @el
    window.test1 = @el

  valid: ->
    @el.valid()

  submit: =>
    pin_ids = _.map(App.Pin.getPinsForAdding(), 'id')
    for pin_id in pin_ids
      do (pin_id) =>
        input = $("<input type='hidden' value=#{pin_id} name='album[pin_ids][]'>")
        @el.find("[data-type=set_pin_ids]").append input
    @el.submit()

##################
##################
##################

class App.AlbumForm extends Spine.Controller
  events:
    'click [data-type=submit]': 'submitForms'

  constructor: ->
    super
    @album_form  = new AlbumFieldsForm el: @el.find("[data-type='album']")
    @images_form = new App.PinUploadForm el: @el.find("[data-type=images]")

    @images_form.bind 'allFilesUploads', @album_form.submit

  submitForms: (e) ->
    e.preventDefault()
    if @album_form.valid()
      $(e.currentTarget).addClass('disabled')
      $(e.currentTarget).next().addClass("disabled")
      @beginUploadsImagesAndThenSaveSupplyDocument()

  beginUploadsImagesAndThenSaveSupplyDocument: ->
    @images_form.submit()


