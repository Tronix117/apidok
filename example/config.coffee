#basePath:       "./docs"
apiUrl:         "http://petstore.swagger.wordnik.com/api"
apiCurrentVersion: "0.2"
apiVersions: ["0.2"]
roles: ["Administrator", "Manager", "Employee", "Consumer"]
headers: []
swaggerVersion: "1.1"
modifiers:
  changeRole: (swaggerOptions, callback, jQuery)-> callback null, true
  changeVersion: (swaggerOptions, callback, jQuery)-> callback null, true
