Forkbin.Views.Lists ||= {}

class Forkbin.Views.Lists.SingleView extends Backbone.View
  template: JST["backbone/templates/lists/single"]
  tagName: "tr"

  events:
    "click .privacy_toggle": "privacyToggle"
    "click .delete_link": "deleteList"

  deleteList: (e) ->
    e.preventDefault()
    target = $(e.currentTarget)

    $.ajax
      type: 'DELETE'
      url: "/lists/#{@model.id}.json"
      success: =>
        collection = @model.collection
        collection.remove @model

        $(@el).remove()

  privacyToggle: (e) ->
    e.preventDefault()
    target = $(e.currentTarget)

    $.ajax
      type: 'PUT'
      url: "/lists/#{@model.id}.json"
      data:
        list:
          is_public: !@model.get('is_public')
      success: (data) =>
        @model.set('is_public', data.list.is_public)
        if data.list.is_public
          target.html('make private')
          target.parent().find('span').html('Public')
        else
          target.html('make public')
          target.parent().find('span').html('Private')
        data

  render: ->
    $(@el).html @template(@model.toJSON())
    @
