User: 
  id: 
    type: "long"
  lastName: 
    type: "string"
  phone: 
    type: "string"
  username: 
    type: "string"
  email: 
    type: "string"
  userStatus: 
    allowableValues:
      valueType: "LIST"
      values: [
        "1-registered"
        "2-active"
        "3-closed"
      ]
    description: "User Status"
    type: "int"
  firstName: 
    type: "string"
  password: 
    type: "string"