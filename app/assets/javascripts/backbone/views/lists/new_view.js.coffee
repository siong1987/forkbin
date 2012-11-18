Forkbin.Views.Lists ||= {}

class Forkbin.Views.Lists.NewView extends Backbone.View
  template: JST["backbone/templates/lists/new"]

  events:
    "click button": "newList"

  newList: (e) ->
    e.preventDefault()

    target = $(e.currentTarget)
    val = target.parent().prev().val()

    unless val == ""
      $.post('/lists.json', {list: {name: val}})
        .success (data) ->
          Backbone.history.navigate "/lists/#{data.list.id}",
            trigger: true
            replace: true
          $('.close-reveal-modal').click()
    else
      alert "You need to provide a list name."

  render: ->
    $(@el).html @template()
    @
