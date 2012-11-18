Forkbin.Views.Lists ||= {}

class Forkbin.Views.Lists.ShowView extends Backbone.View
  template: JST["backbone/templates/lists/show"]
  className: "single_list"

  initialize: ->
    _.bindAll(@, 'getModel', 'addOneItem', 'addAllItems')

    @items = new Forkbin.Collections.ItemsCollection()
    @items.bind('add', @addOneItem)
    @items.bind('reset', @addAllItems)

    @model.bind('change', @getModel)

  events:
    "keypress .new_item": "newItem"
    "click .gh_button": "fork"
    "click .social_count": "showForks"

  showForks: (e) ->
    e.preventDefault()
    Backbone.history.navigate "/lists/#{@model.id}/forks",
      trigger: true
      replace: true

  fork: (e) ->
    e.preventDefault()
    if isLoggedIn
      $.post("/lists/#{@model.id}/fork.json")
        .success (data) ->
          Backbone.history.navigate "/lists/#{data.list.id}",
            trigger: true
            replace: true
    else
      window.location = "/signup"

  newItem: (e) ->
    if (e.keyCode == 13 &&  !e.shiftKey)
      target = $(e.currentTarget)

      val = target.val()
      @items.add [{name: val, checked: 'false'}]
      target.val("")

      @items.update(@model.get('id'))

  getModel: (list) ->
    if isLoggedIn
      @isOwner = (currentUser._id == @model.get('user_id'))
    else
      @isOwner = false

    @$('.list_title').html(list.get('name'))
    @items.add(list.get('items'))

    @$('.social_count').html list.get('fork_count')
    if (currentUser && list.get('user_id') == currentUser._id)
      @$('#footer').removeClass("hide")

  addAllItems: ->
    @items.each(@addOneItem)

  addOneItem: (item) ->
    view = new Forkbin.Views.Items.SingleView
      model: item
      list_id: @model.get('id')
      isOwner: @isOwner
    @$('ul').append view.render().el

  render: ->
    $(@el).html @template()
    @

class Forkbin.Views.Lists.MainShowView extends Forkbin.Views.Lists.ShowView
  template: JST["backbone/templates/lists/main_show"]
  className: "todo"
