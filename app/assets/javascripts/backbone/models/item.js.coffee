class Forkbin.Models.Item extends Backbone.Model
  paramRoot: 'item'
  name: 'item'

class Forkbin.Collections.ItemsCollection extends Backbone.Collection
  model: Forkbin.Models.Item

  update: (id) ->
    items = @toJSON().map (k) ->
      k.item
    $.ajax
      type: 'PUT'
      url: "/lists/#{id}/update_items.json"
      data:
        items: items
