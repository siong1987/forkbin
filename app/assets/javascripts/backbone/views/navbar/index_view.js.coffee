Forkbin.Views.NavBar ||= {}

class Forkbin.Views.NavBar.IndexView extends Backbone.View
  authenticatedTemplate: JST["backbone/templates/navbar/authenticated"]
  unauthenticatedTemplate: JST["backbone/templates/navbar/unauthenticated"]

  events:
    "click .new_list_link": "newList"

  newList: (e) ->
    e.preventDefault()
    view = new Forkbin.Views.Lists.NewView()

    model = $('#my_modal')
    model.html view.render().el
    model.reveal()

  render: ->
    if isLoggedIn
      $(@el).html @authenticatedTemplate()
    else
      $(@el).html @unauthenticatedTemplate()
    @
