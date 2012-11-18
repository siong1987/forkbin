class Forkbin.Routers.ListsRouter extends Backbone.Router
  index: ->
    lists = new Forkbin.Collections.ListsCollection()
    view = new Forkbin.Views.Lists.IndexView
      lists: lists
    $('#content').html(view.render().el)
    lists.fetch()

  show: (id) ->
    list = new Forkbin.Models.List()
    list.url = "/lists/#{id}.json"

    view = new Forkbin.Views.Lists.ShowView
      model: list
    $('#content').html(view.render().el)

    list.fetch()
