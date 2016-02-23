class App.FormValidator extends Spine.Controller
  constructor: ->
    super
    @initFormValidator()

  initFormValidator: ->
    @el.validate
      ignore: ""
      
      highlight: (element) ->
        $(element).closest(".form-group").addClass "has-error"
        return

      unhighlight: (element) ->
        $(element).closest(".form-group").removeClass "has-error"
        return

      errorElement: "span"
      errorClass: "help-block"
  
