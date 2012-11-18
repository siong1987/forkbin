Forkbin.Views.Welcome ||= {}

class Forkbin.Views.Welcome.IndexView extends Backbone.View
  template: JST["backbone/templates/welcome/index"]

  render: ->
    $(@el).html @template()
    @
