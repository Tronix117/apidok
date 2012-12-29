window.extend = (target)->
  target[name] = arg[name] for name in Object.keys arg for arg in arguments
  target

class SwaggerUi extends Backbone.Router

  # Defaults
  dom_id: "swagger_ui"

  # Attributes
  options: null
  api: null
  headerView: null
  mainView: null

  # SwaggerUi accepts all the same options as SwaggerApi
  initialize: (options={}) ->
    # Allow dom_id to be overridden
    if options.dom_id?
      @dom_id = options.dom_id
      delete options.dom_id

    # Create an empty div which contains the dom_id
    $('body').append('<div id="' + @dom_id + '"></div>') if not $('#' + @dom_id)?

    @options = options

    # Set the callbacks
    @options.success = => @render()
    @options.progress = (d) => @showMessage(d)
    @options.failure = (d) => @onLoadFailure(d)

    # Create view to handle the header inputs
    model = new Backbone.Model
      role: @options.role
      version: @options.version
      roleList: CONFIG.roles
      versionList: CONFIG.apiVersions
    model.on 'change:role change:version', (model, value, changed)=> @api[key] = value if change for key, change of changed.changes
        
    @headerView = new HeaderView({model: model, el: $('#header')}).render()

  # Event handler for when url/key is received from user
  updateSwaggerUi: (data) ->
    extend @options, data
    @load()

  # Create an api and render
  load: ->
    # Initialize the API object
    @mainView?.clear()
    @api = new SwaggerApi(@options)
    @api.role = @options.role
    @api.version = @options.version

  # This is bound to success handler for SwaggerApi
  #  so it gets called when SwaggerApi completes loading
  render:() ->
    @showMessage('Finished Loading Resource Information. Rendering Swagger UI...')
    @mainView = new MainView({model: @api, el: $('#' + @dom_id)}).render()
    @showMessage()
    switch @options.docExpansion
     when "full" then Docs.expandOperationsForResource('')
     when "list" then Docs.collapseOperationsForResource('')
    @options.onComplete(@api, @) if @options.onComplete
    setTimeout(
      =>
        Docs.shebang()
      400
    )

  # Shows message on topbar of the ui
  showMessage: (data = '') ->
    $('#message-bar').removeClass 'message-fail'
    $('#message-bar').addClass 'message-success'
    $('#message-bar').html data

  # shows message in red
  onLoadFailure: (data = '') ->
    $('#message-bar').removeClass 'message-success'
    $('#message-bar').addClass 'message-fail'
    val = $('#message-bar').html data
    @options.onFailure(data) if @options.onFailure?
    val

window.SwaggerUi = SwaggerUi
