#basePath:       "./docs"
title: "Apidok"
swaggerVersion: "1.1"
apiUrl: "http://petstore.swagger.wordnik.com/api"
apiKey: null
apiKeyName: "X-AccessToken"
apiCurrentVersion: "0.2"
apiVersions: ["0.1", "0.2"]
roles: ["Consumer", "Employee", "Manager", "Administrator"]
headers: 
  "X-App-Id": "com.apidok.doc"
  "Accept-Language": "en-US"
beforeLoad: (callback)-> CONFIG.onVersionChange.call @, ()=> CONFIG.onRoleChange.call @, callback
afterLoad: ()->
onRoleChange: (callback)->
  callback() # placeholder because the code exemple bellow doesn't work with swagger api

  @showMessage "Obtaining access for role #{@api.role}..."
  @$.post CONFIG.apiUrl + '/sessions/dummy', { role: @api.role }, (data)->
    @api.apiKey = data.access_token
    callback()
  , 'json'
onVersionChange: (callback)-> 
  @api.headers['X-Api-Version'] = @api.version
  callback()