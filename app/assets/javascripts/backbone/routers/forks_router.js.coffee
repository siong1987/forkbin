class Forkbin.Routers.ForksRouter extends Backbone.Router
  index: (list_id) ->
    lists = new Forkbin.Collections.ListsCollection()
    view = new Forkbin.Views.Forks.IndexView
      lists: lists
    $('#content').html(view.render().el)
    lists.url = "/lists/#{list_id}/forks.json"
    lists.fetch()
