window.originalLocalStorage = window.localStorage

data = {}

localStorage = new Proxy data,
  set: (obj, prop, value)->
    if prop == 'test'
      throw new Error 'test is protected'

    obj[prop] = value

Object.defineProperty window, 'localStorage',
  get: -> localStorage
  set: ->
    throw new Error('Using file-local-storage plugin - don\'t try to override')
