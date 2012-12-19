require './mixins'

fs     = require 'fs'
coffee = require 'coffee-script'

class Apidok

  models: {}
  apis: {}
  resources: {}
  roles: ['all']
  config: 
    input: ''
    output: ''
    version: null
    extendedModels: false
    enableRoles: false
    simpleDatatypes: ['path', 'void', 'byte', 'boolean', 'int', 'long', 'float', 'double', 'string', 'Date']

  constructor: (config)->
    extend @config, config
    console.log "   : Generate documentation in #{@config.output}"
    @loadResources().loadModels().loadApis().writeResources().writeApis()
    console.log '   : Documentation generated!!'

  getContentDir: (baseprefix = '', aliasSeparator = '/', recursive = true, prefix = '')->
    raw = {}
    dir = @config.input + '/' + baseprefix + '/' + prefix + '/'
    files = fs.readdirSync dir
    files.forEach (file)->
      stat = fs.statSync dir + file
      if not stat?.isDirectory()
        raw[(prefix + file.replace /\..*$/, '').replace /\//g, aliasSeparator] = coffee.eval fs.readFileSync dir + file, 'utf8'
      else if recursive
        extend raw, @getContentDir baseprefix, aliasSeparator, recursive, prefix + file
    raw
            
  extendModel: (id)->
    return @ unless @models[id].properties.$extend
    unless @models[@models[id].properties.$extend]
      console.error '     - Model `' + @models[id].properties.$extend + '` does not exist for extend in model `' + id + '`'
      return @
    @extendModel @models[id] if @models[@models[id].properties.$extend].properties.$extend
    @models[id].properties = extend {}, @models[@models[id].properties.$extend].properties, @models[id].properties
    delete @models[id].properties.$extend
    @

  loadResources: ->
    raw = (@getContentDir null, null, false)['resources']
    
    @roles = raw.roles if @config.enableRoles

    for role in @roles
      @resources[role] = extend {}, raw # copy of object
      @resources[role].apis = [] # reset
      @resources[role].discoveryUrl = @resources[role].basePath
      @resources[role].basePath = @resources[role].apiUrl if @resources[role].apiUrl?
      (@resources[role].apis.push api if not api.roles or -1 < ([].concat api.roles).indexOf role) for api in raw.apis

    console.log '     + Resources loaded'
    @

  loadModels: ->
    raw = extend raw or {}, obj for k, obj of @getContentDir 'models', '::'
    
    for id, model of raw
      @models[id] = 
        id: id.replace /\$.*$/, ''
        properties: model    
      @models[id.replace /\$.*$/, ''] = @models[id] if id.match /\$default$/

    if @config.extendedModels
      @extendModel id for id, model of @models

    console.log '     + Models loaded'
    @

  modelsForModel: (model)->
    models = [model]
    for key, property of model.properties
      models.push @modelsForModel @models[property.items.$ref] if @models[property.items.$ref] if -1 < ['List', 'Set', 'Array'].indexOf property.type
    models

  modelsForApis: (apis)->
    models = []
    
    possibleModels = []
    for api in apis
      for operation in api.operations
        possibleModels.push operation.responseClass.replace(/^.*\[(.*)\]$/,'$1') unless -1 < @config.simpleDatatypes.indexOf operation.responseClass
        if operation.parameters
          for parameter in operation.parameters
            possibleModels.push parameter.dataType.replace(/^.*\[(.*)\]$/,'$1') unless -1 < @config.simpleDatatypes.indexOf parameter.dataType

    (models = models.concat @modelsForModel @models[modelName] if @models[modelName]) for modelName in possibleModels

    #(models.filter (m, p)-> (models.indexOf m) == p) # Remove duplicated
    _models = {}
    _models[model.id] = model for model in models
    _models

  loadApis: ->
    raw = @getContentDir 'apis'
    for role in @roles
      @apis[role] = {}
      for path, apis of raw
        if role == 'all' then apisRole = apis
        else
          apisRole = []
          for api in apis
            _api = extend {}, api
            _api.operations = []
            for operation in api.operations
              _api.operations.push operation if not operation.roles or -1 < ([].concat operation.roles).indexOf role
            apisRole.push _api #if api.operations.length

        @apis[role][path] = extend {}, @resources[role],
          resourcePath: '/' + path
          apis: apisRole
          models: @modelsForApis apis

    console.log '     + Apis loaded'
    @

  writeResources: ->
    for role in @roles
      @resources[role].basePath = @resources[role].discoveryUrl
      delete @resources[role].discoveryUrl
      fs.writeFileSync(@config.output + (@config.version and '/' + @config.version or '') + (role isnt 'all' and '/' + role or '') + '/resources.json', JSON.stringify(@resources[role]))
    console.log '     + Resources writed'
    @

  writeApis: ->
    for role in @roles
      fs.writeFileSync @config.output + (@config.version and '/' + @config.version or '') + (role isnt 'all' and '/' + role or '') + '/' + path + '.json', JSON.stringify apis for path, apis of @apis[role]
    console.log '     + Apis writed'
    @

module.exports = Apidok