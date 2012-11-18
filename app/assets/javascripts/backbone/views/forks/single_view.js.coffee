Forkbin.Views.Forks ||= {}

class Forkbin.Views.Forks.SingleView extends Backbone.View
  template: JST["backbone/templates/forks/single"]
  tagName: "tr"

  render: ->
    $(@el).html @template(@model.toJSON())
    @
