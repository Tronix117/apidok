class HeaderView extends Backbone.View
  events:
    'click #explore'                : 'changeRole'
    'keyup #input_apiKey'           : 'changeRole'

  initialize: ->

  changeRole: ->
    @update()

  update: (version, role, trigger) ->
    apiKey = 'getNewApiKeyForRoleAndVersion'
    @trigger 'update-swagger-ui', {apiKey:apiKey} if trigger
