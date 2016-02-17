Spine.Controller.view = (name)->
  JST["app/views/#{name}"]
  
Spine.Controller.include
  view: (name) ->
    Spine.Controller.view(name)
