new (require './lib/dokify')
  input:          __dirname + '/doc'
  output:         __dirname + '/dist'
  extendedModels: true # Model can be extended: Pet$default, Pet$extended, ...