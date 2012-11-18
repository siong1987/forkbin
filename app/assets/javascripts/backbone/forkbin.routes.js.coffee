$(document).ready ->
  if (typeof(enableBackbone) != "undefined" && enableBackbone)
    if isLoggedIn
      routes =
        # TODO: need IE to actually test this
        # for IE rerouting for route with !
        "!*splat":
          "HomeRouter": "reroute"

        "":
          "NavbarRouter": "index"
          "ListsRouter": "index"

        "lists/:id":
          "NavbarRouter": "index"
          "ListsRouter": "show"

        "lists/:id/forks":
          "NavbarRouter": "index"
          "ForksRouter": "index"

        ":username":
          "NavbarRouter": "index"
          "UsersRouter": "show"
    else
      routes =
        # TODO: need IE to actually test this
        # for IE rerouting for route with !
        "!*splat":
          "HomeRouter": "reroute"

        "":
          "NavbarRouter": "index"
          "WelcomeRouter": "index"

        "lists/:id":
          "NavbarRouter": "index"
          "ListsRouter": "show"

        "lists/:id/forks":
          "NavbarRouter": "index"
          "ForksRouter": "index"

        ":username":
          "NavbarRouter": "index"
          "UsersRouter": "show"

    Backbone.Routes.prefix = Forkbin.Routers
    Backbone.Routes.map routes
    Backbone.history.start
      pushState: true
