require './mixins'

fs     = require 'fs'
coffee = require 'coffee-script'

class Dokify

  models: {}
  apis: {}
  resources: {}
  config: 
    input: ''
    output: ''
    extendedModels: false

  constructor: (config)->
    extend @config, config
    @loadResources().loadModels().loadApis().writeResources().writeApis()

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
      console.error '-- Model `' + @models[id].properties.$extend + '` does not exist for extend in model `' + id + '`'
      return @
    @extendModel @models[id] if @models[@models[id].properties.$extend].properties.$extend
    @models[id].properties = extend {}, @models[@models[id].properties.$extend].properties, @models[id].properties
    delete @models[id].properties.$extend
    @

  loadResources: ()->
    @resources = (@getContentDir null, null, false)['resources']
    console.log '- Resources loaded'
    @

  loadModels: ()->
    raw = extend raw or {}, obj for k, obj of @getContentDir 'models', '::'
    
    for id, model of raw
      @models[id] = 
        id: id.replace /\$.*$/, ''
        properties: model    

    if @config.extendedModels
      @extendModel id for id, model of @models

    console.log '- Models loaded'
    @

  modelsForApis: (apis)->
    simpleDatatypes = []
    for api in apis
        #responseClass
      console.log api.operations 
    []

  loadApis: ()->
    raw = @getContentDir 'apis'
    for path, apis of raw
      @apis[path] = extend {}, @resources,
        resourcePath: '/' + path
        apis: apis
        models: @modelsForApis apis

    console.log '- Apis loaded'
    @

  writeResources: ()->
    fs.writeFileSync @config.output + '/resources.json', JSON.stringify @resources
    console.log '- Resources writed'
    @

  writeApis: ()->
    fs.writeFileSync @config.output + '/' + path + '.json', JSON.stringify apis for path, apis of @apis
    console.log '- Apis writed'
    @

module.exports = Dokify