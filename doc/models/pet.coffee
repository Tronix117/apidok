Pet: 
  id:
    type: "Long"
  tag:
    type: "Tag"
  status:
    type:        "String"
    description: "pet status in the store"
    allowableValues: 
      valueType: "LIST"
      values:    [
        "available"
        "pending"
        "sold"
      ]
  happiness:
    type:        "Int"
    description: "how happy the Pet appears to be, where 10 is 'extremely happy'"
    allowableValues: 
      valueType: "RANGE"
      min:       1
      max:       10
  categories:
    type:        "List"
    description: "categories that the Pet belongs to"
    items:       
      $ref: "Category"