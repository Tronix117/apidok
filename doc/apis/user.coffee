[
  path: "/user.{format}"
  description: "Operations about user"
  operations: [
    httpMethod: "POST"
    summary: "Create user"
    notes: "This can only be done by the logged in user."
    responseClass: "void"
    nickname: "createUser"
    parameters: [
      description: "Created user object"
      paramType: "body"
      required: true
      allowMultiple: false
      dataType: "User"
    ]
  ]
,
  path: "/user.{format}/createWithArray"
  description: "Operations about user"
  operations: [
    httpMethod: "POST"
    summary: "Creates list of users with given input array"
    responseClass: "void"
    nickname: "createUsersWithArrayInput"
    parameters: [
      description: "List of user object"
      paramType: "body"
      required: true
      allowMultiple: false
      dataType: "Array[User]"
    ]
  ]
,
  path: "/user.{format}/createWithList"
  description: "Operations about user"
  operations: [
    httpMethod: "POST"
    summary: "Creates list of users with given list input"
    responseClass: "void"
    nickname: "createUsersWithListInput"
    parameters: [
      description: "List of user object"
      paramType: "body"
      required: true
      allowMultiple: false
      dataType: "List[User]"
    ]
  ]
,
  path: "/user.{format}/{username}"
  description: "Operations about user"
  operations: [
    httpMethod: "GET"
    summary: "Get user by user name"
    responseClass: "User"
    nickname: "getUserByName"
    parameters: [
      name: "username"
      description: "The name that needs to be fetched. Use user1 for testing."
      paramType: path
      required: true
      allowMultiple: false
      dataType: "string"
    ]
    errorResponses: [
      code: 400
      reason: "Invalid username supplied"
    ,
      code: 404
      reason: "User not found"
    ]
  ]
,
  path: "/user.{format}/login"
  description: "Operations about user"
  operations: [
    httpMethod: "GET"
    summary: "Logs user into the system"
    responseClass: "string"
    nickname: "loginUser"
    parameters: [
      name: "username"
      description: "The user name for login"
      paramType: "query"
      required: true
      allowMultiple: false
      dataType: "string"
    ,
      name: "password"
      description: "The password for login in clear text"
      paramType: "query"
      required: true
      allowMultiple: false
      dataType: "string"
    ]
    errorResponses: [
      code: 400
      reason: "Invalid username and password combination"
    ]
  ]
,
  path: "/user.{format}/logout"
  description: "Operations about user"
  operations: [
    httpMethod: "GET"
    summary: "Logs out current logged in user session"
    responseClass: "void"
    nickname: "logoutUser"
  ]
]