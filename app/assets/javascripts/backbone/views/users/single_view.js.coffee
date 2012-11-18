Forkbin.Views.Users ||= {}

class Forkbin.Views.Users.SingleView extends Backbone.View
  template: JST["backbone/templates/users/single"]
  tagName: "tr"

  render: ->
    $(@el).html @template(@model.toJSON())
    @
