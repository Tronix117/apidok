fs          = require 'fs'
path        = require 'path'
{exec}      = require 'child_process'

fs.existsSync = fs.existsSync || path.existsSync # retrocompatibility node.js

class App

  sourceFiles: []

  clean: ->
    console.log 'Clearing dist...'
    exec 'rm -rf dist'

  dist: ->
    console.log "Build distribution in ./#{@options.output}"
    fs.mkdirSync(@options.output) if not fs.existsSync(@options.output)
    fs.mkdirSync("#{@options.output}/js") if not fs.existsSync("#{@options.output}/js")
    configContent = 'window.CONFIG = ' + fs.readFileSync @options.input + '/config.coffee', 'utf8'
    appContents = [configContent]
    remaining = @sourceFiles.length
    for file, index in @sourceFiles then do (file, index) ->
      console.log "   : Reading #{file}"
      fs.readFile file, 'utf8', (err, fileContents) ->
        throw err if err
        appContents.push fileContents
        precompileTemplates() if --remaining is 0
    @_generateDoc()

    precompileTemplates= =>
      console.log '   : Precompiling templates...'
      templateFiles  = fs.readdirSync('app/templates')
      templateContents = new Array remaining = templateFiles.length
      for file, index in templateFiles then do (file, index) =>
        console.log "   : Compiling app/templates/#{file}"
        exec "handlebars app/templates/#{file} -f #{@options.output}/_#{file}.js", (err, stdout, stderr) =>
          throw err if err
          fs.readFile "#{@options.output}/_#{file}.js", 'utf8', (err, fileContents) =>
            throw err if err
            templateContents[index] = fileContents
            fs.unlink "#{@options.output}/_#{file}.js"
            if --remaining is 0
              templateContents.push '\n\n'
              fs.writeFile "#{@options.output}/_apidok-ui-templates.js", templateContents.join('\n\n'), 'utf8', (err) ->
                throw err if err
                build()

    build = =>
      console.log '   : Collecting Coffeescript source...'

      appContents.push '\n\n'
      fs.writeFile "#{@options.output}/_apidok-ui.coffee", appContents.join('\n\n'), 'utf8', (err) =>
        throw err if err
        console.log '   : Compiling...'
        exec "coffee --compile #{@options.output}/_apidok-ui.coffee", (err, stdout, stderr) =>
          throw err if err
          fs.unlink "#{@options.output}/_apidok-ui.coffee"
          console.log '   : Combining with javascript...'
          exec "cat lib/doc.js #{@options.output}/_apidok-ui-templates.js #{@options.output}/_apidok-ui.js > #{@options.output}/js/apidok-ui.js", (err, stdout, stderr) =>
            throw err if err
            fs.unlink "#{@options.output}/_apidok-ui.js"
            fs.unlink "#{@options.output}/_apidok-ui-templates.js"
            console.log '   : Minifying all...'
            exec 'java -jar "./bin/yuicompressor-2.4.7.jar" --type js -o ' + @options.output + '/js/apidok-ui.min.js ' + @options.output + '/js/apidok-ui.js', (err, stdout, stderr) =>
              throw err if err
              pack()

    pack = =>
      console.log '   : Packaging...'
      exec 'cp -r app/assets/* ' + @options.output
      console.log '   !'

  _generateDoc: ->
    fs.mkdirSync @options.output + '/docs' if not fs.existsSync(@options.output + '/docs')
    new (require './utils/apidok')
      input:          @options.input
      output:         @options.output + '/docs'
      extendedModels: @options['extended-models']
      roles:          @options['enable-roles']
      version:        @options.version

  spec: -> exec "open spec.html", (err, stdout, stderr) -> throw err if err

  watch: ->
    # Function which watches all files in the passed directory
    watchFiles = (dir, recursive) =>
      files = fs.readdirSync(dir)
      for file, index in files then do (file, index) =>
        return watchFiles(fp, true) if fs.statSync(fp = dir + '/' + file).isDirectory()
        console.log "   : " + fp
        fs.watchFile fp, (curr, prev) =>
          if +curr.mtime isnt +prev.mtime
            @dist()

    notify "Watching source files for changes..."

    # Watch specific source files
    for file, index in @sourceFiles then do (file, index) ->
      console.log "   : #{file}"
      fs.watchFile file, (curr, prev) ->
        if +curr.mtime isnt +prev.mtime
          @dist()

    # watch all files in these folders
    watchFiles("app/templates")
    watchFiles("app/assets")
    watchFiles("app/tests")
    watchFiles(@options.input, true)

  constructor: (options)->
    options = options or {}
    @options =
      input: options.input or './example' 
      output: options.output or './dist'
      'extended-models': options['extended-models'] 
      roles: options['enable-roles']
      version: options.version or false

    @sourceFiles = ((dir + '/' + file for file in fs.readdirSync(dir) for dir in ['app/routers', 'app/views']).reduce (prev,current)->(prev || []).concat current).concat ['app/main.coffee']
    @

notify = (message) ->
  return unless message?
  console.log message
#  options =
#    title: 'CoffeeScript'
#    image: 'bin/CoffeeScript.png'
#  try require('growl') message, options


module.exports = App
