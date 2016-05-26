fakeLocalStorage = ()->
  window.originalLocalStorage = window.localStorage

  data = {}

  getItem = (prop)->
    if data[prop] != undefined then data[prop] else null

  setItem = (prop, value)->
    throw new Error('''Uncaught TypeError: Failed to execute 'setItem' on 'Storage': 2 arguments required, but only 1 present.''') if arguments.length == 1
    switch value
      when undefined then value = 'undefined'
      when null then value = 'null'
      else value = value.toString()
    return if data[prop] == value
    data[prop] = value
    return

  removeItem = (prop)->
    if data[prop] then delete data[prop]

  clear = ->
    data = {}
    return

  localStorage = new Proxy data,
    set: (obj, prop, value)->
      switch prop
        when 'length', 'getItem', 'setItem', 'removeItem' then return
        else return setItem(prop, value)

    get: (obj, prop)->
      switch prop
        when 'length' then return Object.keys(data).length
        when 'getItem' then return getItem
        when 'setItem' then return setItem
        when 'removeItem' then return removeItem
        when 'clear' then return clear
        else
          v = getItem(prop)
          if v != null then v else undefined

  Object.defineProperty window, 'localStorage',
    get: -> localStorage
    set: ->
      throw new Error 'Using file-local-storage plugin - don\'t try to override'

try
  module.exports = fakeLocalStorage
catch
  window.fakeLocalStorage = fakeLocalStorage