[
  path:        "/admin/users"
  description: "Moderate users"
  operations:  [
    httpMethod:     "GET"
    nickname:       "getUsers"
    summary:        "List users"
    responseClass:  "Array[User]"
  ]
,
  path:        "/admin/users/{userId}"
  description: "Moderate user"
  operations:  [
    httpMethod:     "GET"
    summary:        "Get a user by its id"
    responseClass:  "User"
    nickname:       "getUserById"
    parameters: [
      name: "userId"
      description: "The name that needs to be fetched. Use user1 for testing."
      paramType: "path"
      required: true
      dataType: "int"
    ]
  ]
]