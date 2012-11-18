class Forkbin.Routers.WelcomeRouter extends Backbone.Router
  cache: ["index"]
  index: ->
    view = new Forkbin.Views.Welcome.IndexView
    $('#content').html(view.render().el)

    # Touring London list
    list = new Forkbin.Models.List()
    list.url = "/lists/5050f7a8acfe031300000001.json"
    view = new Forkbin.Views.Lists.MainShowView
      model: list
    $('#container').append(view.render().el)
    list.fetch()

    # Cook a healthy meal list
    list = new Forkbin.Models.List()
    list.url = "/lists/5050f82bacfe03100000000f.json"
    view = new Forkbin.Views.Lists.MainShowView
      model: list
    $('#container').append(view.render().el)
    list.fetch()

    # Move to Sunnyvale list
    list = new Forkbin.Models.List()
    list.url = "/lists/5050f872acfe03130000003b.json"
    view = new Forkbin.Views.Lists.MainShowView
      model: list
    $('#container').append(view.render().el)
    list.fetch()
