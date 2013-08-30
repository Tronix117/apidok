[
  path:        "/pet.{format}/{petId}"
  description: "Operations about pets"
  operations:  [
    httpMethod:     "GET"
    nickname:       "getPetById"
    summary:        "Find pet by its unique ID"
    notes:          "Only Pets which you have permission to see will be returned"
    responseClass:  "Pet"
    parameters:     [
      paramType:       "path"
      name:            "petId"
      description:     "ID of pet that needs to be fetched"
      dataType:        "String"
      required:        true
      allowMultiple:   false
      allowableValues: 
        max:       10
        min:       0
        valueType: "RANGE"
    ]
    errorResponses: [
        code:   400
        reason: "Raised if a user supplies an invalid username format"
      ,
        code:   404
        reason: "The user cannot be found"
    ]
  ,
    httpMethod:     "DELETE"
    nickname:       "deletePet"
    summary:        "Delete a pet"
    notes:          "Only manager have access to this feature"
    roles:          ['Administrator', 'Manager']
    parameters:     [
      paramType:       "path"
      name:            "petId"
      description:     "Pet id"
      dataType:        "String"
      required:        true
    ]
  ]
,
  path:        "/pet.{format}"
  description: "Operations about pets"
  operations:  [
    httpMethod:     "POST"
    nickname:       "addPet"
    summary:        "Add a pet"
    notes:          "Only manager have access to this feature"
    roles:          ['Administrator', 'Manager']
    parameters:     [
      paramType:       "body"
      name:            "pet"
      description:     "Pet object"
      dataType:        "Pet"
      required:        true
    ]
  ]
]