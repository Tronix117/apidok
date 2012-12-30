class HeaderView extends Backbone.View
  events: 'change #api_selector select': 'changeSetting'

  render: -> 
    $(@el).html Handlebars.templates.header @model
    @$('select[data-type="' + type + '"] option[value="' + @model.get(type) + '"]').attr('selected', 'selected') for type of @model.attributes

  changeSetting: (e)-> @model.set ($el = $(e.target)).attr('data-type'), $el.val()
