fs          = require 'fs'
path        = require 'path'
{exec}      = require 'child_process'

tasks = {}

task = (alias, description, method)->
  tasks[alias] =
    alias: alias
    description: description
    method: method

runTask = (alias)-> tasks[alias] && tasks[alias].method()


sourceFiles  = [
  'routers/SwaggerUi'
  'views/HeaderView'
  'views/MainView'
  'views/ResourceView'
  'views/OperationView'
  'views/StatusCodeView'
  'views/ParameterView'
  'views/SignatureView'
  'views/ContentTypeView'
]


task 'clean', 'Removes distribution', ->
  console.log 'Clearing dist...'
  exec 'rm -rf dist'

task 'dist', 'Build a distribution', ->
  console.log "Build distribution in ./dist"
  fs.mkdirSync('dist') if not path.existsSync('dist')
  fs.mkdirSync('dist/lib') if not path.existsSync('dist/lib')

  appContents = new Array remaining = sourceFiles.length
  for file, index in sourceFiles then do (file, index) ->
    console.log "   : Reading app/#{file}.coffee"
    fs.readFile "app/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      precompileTemplates() if --remaining is 0

  precompileTemplates= ->
    console.log '   : Precompiling templates...'
    templateFiles  = fs.readdirSync('app/template')
    templateContents = new Array remaining = templateFiles.length
    for file, index in templateFiles then do (file, index) ->
      console.log "   : Compiling app/template/#{file}"
      exec "handlebars app/template/#{file} -f dist/_#{file}.js", (err, stdout, stderr) ->
        throw err if err
        fs.readFile 'dist/_' + file + '.js', 'utf8', (err, fileContents) ->
          throw err if err
          templateContents[index] = fileContents
          fs.unlink 'dist/_' + file + '.js'
          if --remaining is 0
            templateContents.push '\n\n'
            fs.writeFile 'dist/_swagger-ui-templates.js', templateContents.join('\n\n'), 'utf8', (err) ->
              throw err if err
              build()


  build = ->
    console.log '   : Collecting Coffeescript source...'

    appContents.push '\n\n'
    fs.writeFile 'dist/_swagger-ui.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      console.log '   : Compiling...'
      exec 'coffee --compile dist/_swagger-ui.coffee', (err, stdout, stderr) ->
        throw err if err
        fs.unlink 'dist/_swagger-ui.coffee'
        console.log '   : Combining with javascript...'
        exec 'cat lib/doc.js dist/_swagger-ui-templates.js dist/_swagger-ui.js > dist/swagger-ui.js', (err, stdout, stderr) ->
          throw err if err
          fs.unlink 'dist/_swagger-ui.js'
          fs.unlink 'dist/_swagger-ui-templates.js'
          console.log '   : Minifying all...'
          exec 'java -jar "./bin/yuicompressor-2.4.7.jar" --type js -o ' + 'dist/swagger-ui.min.js ' + 'dist/swagger-ui.js', (err, stdout, stderr) ->
            throw err if err
            pack()

  pack = ->
    console.log '   : Packaging...'
    exec 'cp -r lib dist'
    exec 'cp -r app/assets/* dist'
    console.log '   !'

task 'spec', "Run the test suite", ->
  exec "open spec.html", (err, stdout, stderr) ->
    throw err if err

task 'watch', 'Watch source files for changes and autocompile', ->
  # Function which watches all files in the passed directory
  watchFiles = (dir) ->
    files = fs.readdirSync(dir)
    for file, index in files then do (file, index) ->
      console.log "   : " + dir + "/#{file}"
      fs.watchFile dir + "/#{file}", (curr, prev) ->
        if +curr.mtime isnt +prev.mtime
          invoke 'dist'

  notify "Watching source files for changes..."

  # Watch specific source files
  for file, index in sourceFiles then do (file, index) ->
    console.log "   : " + "app/#{file}.coffee"
    fs.watchFile "app/#{file}.coffee", (curr, prev) ->
      if +curr.mtime isnt +prev.mtime
        invoke 'dist'

  # watch all files in these folders
  watchFiles("app/templates")
  watchFiles("app/assets")
  watchFiles("app/tests")

notify = (message) ->
  return unless message?
  console.log message
#  options =
#    title: 'CoffeeScript'
#    image: 'bin/CoffeeScript.png'
#  try require('growl') message, options