global.extend = (target)->
  target[name] = arg[name] for name in Object.keys arg for arg in arguments
  target