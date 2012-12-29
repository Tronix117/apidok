$(()->
  window.swaggerUi = new SwaggerUi
    discoveryUrl: "docs/resources.json"
    apiKey: "special-key"
    dom_id: "swagger-ui-container"
    supportHeaderParams: false
    supportedSubmitMethods: ['get', 'post', 'put']
    onComplete: (swaggerApi, swaggerUi)->
      if console
        console.log "Loaded SwaggerUI"
        console.log swaggerApi
        console.log swaggerUi
      $('pre code').each (i, e)-> hljs.highlightBlock(e)
    onFailure: (data)->
      if console
        console.log "Unable to Load SwaggerUI"
        console.log data
    docExpansion: "none"

  window.swaggerUi.load()
)