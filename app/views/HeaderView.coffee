# HELPER: #iterate
# Iterate over an object.
# 
# {{#iterate obj}} Key: {{__key}} // Value: {{this}} {{/key_value}}
# {{#iterate obj key="customKey"}} Key: {{customKey}} // Value: {{this}} {{/key_value}}
Handlebars.registerHelper 'iterate', (obj, options)-> 
  buffer = ''
  for key, context of obj
    context[options.hash.key or '__key'] = key
    buffer += options.fn context
  buffer


class HeaderView extends Backbone.View
  events: 'change #api_selector select': 'changeSetting'

  render: -> 
    $(@el).html Handlebars.templates.header CONFIG.settings
    @$('select[data-type="' + type + '"] option[value="' + @model.get(type) + '"]').attr('selected', 'selected') for type of @model.attributes

  changeSetting: (e)-> @model.set ($el = $(e.target)).attr('data-type'), $el.val()
