Forkbin.Views.Forks ||= {}

class Forkbin.Views.Forks.IndexView extends Backbone.View
  template: JST["backbone/templates/forks/index"]

  initialize: ->
    _.bindAll(@, 'addOne', 'addAll')

    @options.lists.bind('add', @addOne)
    @options.lists.bind('reset', @addAll)

  addOne: (list) ->
    titleElement = @$('h1')
    if titleElement.html() == "No Forks Available"
      titleElement.html("#{list.get('name')}'s Forks (#{list.collection.length - 1})")

    view = new Forkbin.Views.Forks.SingleView
      model: list
    @$('tbody').append(view.render().el)

  addAll: ->
    @options.lists.each(@addOne)

  render: ->
    $(@el).html @template()
    @
