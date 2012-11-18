#= require jquery_ujs
#= require foundation
#= require underscore
#= require underscore.string
#= require backbone
#= require backbone.rails
#= require backbone_routes
#= require backbone.sync
#= require backbone/forkbin
#= require backbone/forkbin.routes

$ ->
  if (typeof(enableBackbone) != "undefined" && enableBackbone)
    $("a").live 'click', (e) ->
      href = $(e.currentTarget).attr('href')
      if href
        forbiddenHrefs = [ "/logout", "/signup", "/login" ]
        if !(_.str.include(href, '#')) && !_.include(forbiddenHrefs, href) && href.substring(0, 7) != 'http://' && !(e.metaKey || e.ctrlKey) && href.substring(0, 8) != 'https://'
          e.preventDefault()
          Backbone.history.navigate href.substring(1),
            trigger: true

_.mixin(_.string.exports())
