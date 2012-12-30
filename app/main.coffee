window.swaggerUi = new SwaggerUi
  discoveryUrl: (CONFIG.basePath || './docs') + (CONFIG.resourcesFilename || '/resources.json')
  apiKey: CONFIG.apiKey || 'api-key'
  apiKeyName: CONFIG.apiKeyName || 'api_key'
  headers: CONFIG.headers || {}
  dom_id: "swagger-ui-container"
  supportHeaderParams: true
  supportedSubmitMethods: ['get', 'post', 'put']
  onComplete: (swaggerApi, swaggerUi)->
    if console
      console.log "Loaded SwaggerUI"
      console.log swaggerApi
      console.log swaggerUi
    $('pre code').each (i, e)-> hljs.highlightBlock(e)
    CONFIG.afterLoad?.call @
  onFailure: (data)->
    if console
      console.log "Unable to Load SwaggerUI"
      console.log data
  docExpansion: "none"
  settings: CONFIG.settings

window.swaggerUi.$ = $

$ ()->
  # BeforeLoad trigger
  CONFIG.beforeLoad?.call(window.swaggerUi, ()-> window.swaggerUi.load()) or  window.swaggerUi.load()

  if CONFIG.title
    $('a#logo').html CONFIG.title
    document.title = CONFIG.title