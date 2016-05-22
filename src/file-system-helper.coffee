Helpers = require 'coffee/helpers'

module.exports = FileHelper =
  getQuota: ->
    if global.device
      Promise.resolve 5 * 1024 * 1024
    else
      new Promise (res, rej)->
        navigator.webkitPersistentStorage.requestQuota 5 * 1024 * 1024, res, rej

  getFileSystem: ->
    requestFileSystem = global.requestFileSystem || webkitRequestFileSystem
    new Promise (res, rej)=>
      @getQuota()
      .then (bytes)->
        requestFileSystem global.PERSISTENT, bytes, (fs)->
          res fs
        , rej
      .catch (e)=>
        @errorHandler(e)
        rej(e)

  getRoot: ->
    if @root
      Promise.resolve @root
    else
      new Promise (res, rej)=>
        if global.resolveLocalFileSystemURL
          global.resolveLocalFileSystemURL @getStorageDirectory(), (root)=>
            @root = root
            res(root)
          , rej
        else
          @getFileSystem().then (fs)=>
            @root = fs.root
            res @root

  getDeviceID: ->
    if global.device
      Promise.resolve device.uuid
    else
      Promise.resolve '000000'

  saveToFile: (url, destination, filename)->
    if global.cordova
      new Promise (res, rej)->
        fileTransfer = new FileTransfer()
        path = destination + filename
        trustHosts = true
        fileTransfer.download url, path, res, rej, true
    else
      link = document.createElement 'a'
      link.href = url
      link.download = filename
      link.click()
      Promise.resolve()

  shareViaEmail: (fileEntry, filename, subject = null, message = null)->
    url = fileEntry.toURL()
    if global.plugins && global.plugins.socialsharing
      global.plugins.socialsharing.canShareViaEmail ->
        new Promise (res, rej)->
          global.plugins.socialsharing.shareViaEmail(
            message
            subject
            null
            null
            null
            url
            res
            rej
          )
      , ->
        Helpers.alert 'Unable to export via email. Please ensure that you have en email application installed, then try again.'
        Promise.reject()
    else
      link = document.createElement 'a'
      link.href = fileEntry.toURL()
      link.download = filename
      link.click()
      Promise.resolve()

  getStorageDirectory: ->
    if global.cordova
      f = cordova.file
      f.syncedDataDirectory || f.externalApplicationStorageDirectory
    else
      ''

  getInputFile: ->
    new Promise (res, rej)->
      i = document.createElement 'input'
      i.setAttribute 'type', 'file'
      i.addEventListener 'change', ->
        file = i.files[0]
        if file
          res file
        else
          rej()
      i.click()

  getFile: (path, options)->
    new Promise (res, rej)=>
      @getRoot()
      .then (root)=>
        root.getFile path, options, (file)->
          res file
        , (e)=>
          @errorHandler e
          rej e

  readFile: (file)->
    new Promise (res, rej)->
      file.file (file)->
        reader = new FileReader
        reader.onloadend = -> res reader.result
        reader.readAsText file

  getDataFile: (options)->
    @getDataFileName().then (path)=> @getFile path, options

  getDataFileName: ->
    @getDeviceID().then (id)-> "data-#{id}.json"

  readDataFile: ->
    @getDataFile().then @readFile

  deleteDataFile: ->
    new Promise (res)=>
      # Delete existing file
      @getDataFile()
      .then (file)->
        new Promise (res, rej)->
          file.remove(res, rej)
      .then(res)
      .catch(res)

  writeDataFile: ->
    console.log 'Saving'
    @deleteDataFile()
    .then =>
      @getDataFile({ create: true })
      .then (file)=>
        new Promise (res, rej)=>
          file.createWriter (writer)=>
            writer.onwriteend = res
            writer.onerror = rej
            blob = new Blob [@localStorageToString()], type: 'text/plain'
            writer.write blob

  localStorageToString: ->
    exp = {}
    for name, value of localStorage
      exp[name] = value
    JSON.stringify exp

  stringToLocalStorage: (string)->
    obj = JSON.parse string
    localStorage.clear()
    for key, value of obj
      localStorage[key] = value
    return

  clearAllStorage: ->
    localStorage.clear()
    @deleteDataFile()

  errorHandler: (e)->
    console.trace()
    switch e.code
      when FileError.QUOTA_EXCEEDED_ERR
        msg = 'QUOTA_EXCEEDED_ERR'
      when FileError.NOT_FOUND_ERR
        msg = 'NOT_FOUND_ERR'
      when FileError.SECURITY_ERR
        msg = 'SECURITY_ERR'
      when FileError.INVALID_MODIFICATION_ERR
        msg = 'INVALID_MODIFICATION_ERR'
      when FileError.INVALID_STATE_ERR
        msg = 'INVALID_STATE_ERR'
      else
        msg = 'Unknown Error'

    console.log 'Error: ' + msg
