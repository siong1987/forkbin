Forkbin.Views.Users ||= {}

class Forkbin.Views.Users.ShowView extends Backbone.View
  template: JST["backbone/templates/users/show"]

  initialize: ->
    _.bindAll(@, 'addOne', 'addAll')

    @options.lists.bind('add', @addOne)
    @options.lists.bind('reset', @addAll)

  addOne: (list) ->
    titleElement = @$('h1')
    if titleElement.html() == "No Users Found"
      titleElement.html("#{list.get('username')}'s Lists (#{list.collection.length})")

    view = new Forkbin.Views.Users.SingleView
      model: list
    @$('tbody').append(view.render().el)

  addAll: ->
    @options.lists.each(@addOne)

  render: ->
    $(@el).html @template()
    @
