class Forkbin.Routers.HomeRouter extends Backbone.Router
  reroute: (splat) ->
    Backbone.history.navigate splat.substring(1),
      trigger: true
      replace: true
