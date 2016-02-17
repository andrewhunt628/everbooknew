#= require json2
#= require jquery
#= require spine-1.6.1/src/spine
#= require spine-1.6.1/src/manager
#= require spine-1.6.1/src/ajax
#= require spine-1.6.1/src/route
#= require spine-1.6.1/src/relation


#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views


class App extends Spine.Controller
  constructor: ->
    super

window.App = App
