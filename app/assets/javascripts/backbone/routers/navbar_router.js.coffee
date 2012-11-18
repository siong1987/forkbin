class Forkbin.Routers.NavbarRouter extends Backbone.Router
  cache: ["index"]
  index: ->
    view = new Forkbin.Views.NavBar.IndexView
    $('#header_nav').html(view.render().el)
