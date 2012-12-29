$ ()->
  window.swaggerUi = new SwaggerUi
    discoveryUrl: (CONFIG.basePath || './docs') + (CONFIG.resourcesFilename || '/resources.json')
    apiKey: CONFIG.apiKey || 'api-key'
    apiKeyName: CONFIG.apiKeyName || 'api_key'
    headers: CONFIG.headers || {}
    dom_id: "swagger-ui-container"
    supportHeaderParams: true
    supportedSubmitMethods: ['get', 'post', 'put']
    version: CONFIG.currentVersion
    role: CONFIG.roles?[0]
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

  window.swaggerUi.$ = $
  window.swaggerUi.api = window.swaggerUi.options # for the beforeLoad, otherwise .api doesn't exist. @fixme find a cleaner way

  CONFIG.beforeLoad?.call(window.swaggerUi, ()-> window.swaggerUi.load()) or  window.swaggerUi.load()