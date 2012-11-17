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

  getContentDir: (baseprefix = '', aliasSeparator = '::', recursive = true, prefix = '')->
    raw = {}
    dir = @config.input + '/' + baseprefix + '/' + prefix + '/'
    files = fs.readdirSync dir
    files.forEach (file)->
      stat = fs.statSync dir + file
      if not stat?.isDirectory()
        raw[(prefix + file.replace /\..*$/, '').replace /\//g, aliasSeparator] = coffee.eval fs.readFileSync dir + file, 'utf8'
      else if recursive
        raw = extend raw, @getContentDir baseprefix, aliasSeparator, recursive, prefix + file
    raw
            

  loadModels: ()->
    o = extend o || {}, obj for k, obj of @getContentDir 'models'
    return @ unless @config.extendedModels

    #extend models
    #for 

  loadApis: ()->
    raw = @getContentDir 'apis'
    console.log raw

  generateResource: ()->

  generateApis: ()->

module.exports = Dokify