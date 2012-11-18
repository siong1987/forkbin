Forkbin.Views.Lists ||= {}

class Forkbin.Views.Lists.IndexView extends Backbone.View
  template: JST["backbone/templates/lists/index"]

  initialize: ->
    _.bindAll(@, 'addOne', 'addAll')

    @options.lists.bind('add', @addOne)
    @options.lists.bind('reset', @addAll)

  events:
    "click button": "newList"

  newList: (e) ->
    e.preventDefault()
    view = new Forkbin.Views.Lists.NewView()

    model = $('#my_modal')
    model.html view.render().el
    model.reveal()

  addOne: (list) ->
    view = new Forkbin.Views.Lists.SingleView
      model: list
    @$('tbody').append(view.render().el)

  addAll: ->
    @options.lists.each(@addOne)

  render: ->
    $(@el).html @template()
    @
