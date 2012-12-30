#basePath:       "./docs"
title: "Apidok"
swaggerVersion: "1.1"
apiUrl: "http://petstore.swagger.wordnik.com/api"
apiKey: null
apiKeyName: "X-AccessToken"
apiCurrentVersion: "0.2"
settings:
  version:
    label: 'API Version'
    default: "0.2"
    list: ["0.1", "0.2"]
    onChange: (callback)-> 
      @options.headers['X-Api-Version'] = @options.version
      CONFIG.changeDiscoveryUrl.call @
      callback()
  role:
    label: 'Role'
    default: "Consumer"
    list: ["Consumer", "Employee", "Manager", "Administrator"]
    onChange: (callback)->
      callback() # placeholder because the code exemple bellow doesn't work with swagger api

      @showMessage "Obtaining access for role #{@options.role}..."
      @$.post CONFIG.apiUrl + '/sessions/dummy', { role: @options.role }, (data)=>
        CONFIG.changeDiscoveryUrl.call @
        @options.apiKey = data.access_token
        callback()
      , 'json'
headers: 
  "X-App-Id": "com.apidok.doc"
  "Accept-Language": "en-US"
beforeLoad: (callback)-> CONFIG.settings.version.onChange.call @, ()=> CONFIG.settings.role.onChange.call @, callback
afterLoad: ()->
changeDiscoveryUrl: ()-> @options.discoveryUrl = "./docs/#{@options.version}/#{@options.role}/resources.json"