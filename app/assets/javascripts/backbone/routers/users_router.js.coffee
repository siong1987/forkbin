class Forkbin.Routers.UsersRouter extends Backbone.Router
  show: (username) ->
    lists = new Forkbin.Collections.ListsCollection()
    view = new Forkbin.Views.Users.ShowView
      lists: lists
    $('#content').html(view.render().el)
    lists.url = "/users/#{username}.json"
    lists.fetch()
