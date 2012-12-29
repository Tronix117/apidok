class HeaderView extends Backbone.View
  events: 'change #api_selector select': 'changeSetting'

  render: -> $(@el).html Handlebars.templates.header @model

  changeSetting: (e)-> @model.set ($el = $(e.target)).attr('data-type'), $el.val()
