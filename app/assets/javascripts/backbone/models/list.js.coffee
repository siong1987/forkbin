class Forkbin.Models.List extends Backbone.Model
  paramRoot: 'list'
  name: 'list'

class Forkbin.Collections.ListsCollection extends Backbone.Collection
  model: Forkbin.Models.List
  url: '/lists.json'
