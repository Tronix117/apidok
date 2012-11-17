require './mixins'

fs     = require 'fs'
coffee = require 'coffee-script'

class Dokify

  models: {}
  apis: {}
  config: 
    input: ''
    output: ''
    extendedModels: false

  constructor: (config)->
    extend @config, config

    @loadModels()
    @loadApis()

    @generateResource()

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

  loadModels: ()->
    raw = extend raw or {}, obj for k, obj of @getContentDir 'models', '::'
    
    for id, model of raw
      @models[id] = 
        id: id.replace /\$.*$/, ''
        properties: model    

    if @config.extendedModels
      @extendModel id for id, model of @models
    @

  loadApis: ()->
    raw = @getContentDir 'apis'
    for path, api of raw
      @apis

    console.log @apis

{ pet: 
   { path: '/pet.{format}/{petId}',
     description: 'Operations about pets',
     operations: [ [Object], [Object] ] } }

  generateResource: ()->

  generateApis: ()->

module.exports = Dokify