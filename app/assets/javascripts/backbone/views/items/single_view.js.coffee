Forkbin.Views.Items ||= {}

class Forkbin.Views.Items.SingleView extends Backbone.View
  template: JST["backbone/templates/items/single"]
  tagName: "li"

  events:
    "click a.check": "checkItem"
    "click a.remove": "removeItem"
    "mouseover": "toggleRemove"
    "mouseout": "toggleRemove"

  toggleRemove: (e) ->
    if @options.isOwner
      target = $(e.currentTarget)
      removeIcon = target.find('a.remove')
      if removeIcon.hasClass('hide')
        removeIcon.removeClass('hide')
      else
        removeIcon.addClass('hide')

  removeItem: (e) ->
    e.preventDefault()
    if @options.isOwner
      target = $(e.currentTarget)
      collection = @model.collection
      collection.remove @model

      collection.update(@options.list_id)
      $(@el).remove()

  checkItem: (e) ->
    e.preventDefault()
    if @options.isOwner
      target = $(e.currentTarget)

      if (@model.get('checked') == 'true')
        @model.set('checked', 'false')

        imgElement = target.find('img')
        imgElement.attr('src', "/assets/checkbox_no.png")

        textElement = target.next()
        textElement.removeClass('complete')
      else
        @model.set('checked', 'true')

        imgElement = target.find('img')
        imgElement.attr('src', "/assets/checkbox_yes.png")

        textElement = target.next()
        textElement.addClass('complete')

      @model.collection.update(@options.list_id)

  render: ->
    $(@el).html @template(@model.toJSON())
    @
