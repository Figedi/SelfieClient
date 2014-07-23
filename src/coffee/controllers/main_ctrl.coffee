'use strict'
require('../config/static')
require('../factories/overlay')
require('../factories/selfie_server')

MainCtrl = ['$scope', 'Server', 'Config', 'overlay', ($scope, Server, Config, overlay) ->

  testForB64 = (image) ->
    console.log "image", image
    Config.base64Regex.test(image)

  uploadToServer = (opts) ->
    $scope.server.uploadRequested = true
    console.log "upload"
    Server.upload(opts)
    .success (data, status, headers, config) ->
      overlay.show('Vielen Dank für dein Selfie!')
      $scope.server.fileName = data.file.name
      $scope.server.uploadRequested = false
    .error (data, status, headers, config) ->
      overlay.show({text: 'Hochladen fehlgeschlagen, versuch\'s doch nochmal!', type: 'error'})
      console.log "error while uploading"
      $scope.server.fileName = ''
      $scope.server.uploadRequested = false

  sendToEmail = (opts) ->
    $scope.server.uploadRequested = true
    console.log "email"
    Server.email(opts)
    .success (data, status, headers, config) ->
      overlay.show('Hochladen erfolgreich!')
      console.log "success", data
      $scope.server.uploadRequested = false
      selfieNav.popPage()
      $scope.test.imageSrc = null #reset image
      $scope.userMedia.imageAvailable = false #reset to standard view (logo view)
    .error (data, status, headers, config) ->
      $scope.server.fileName = ''
      $scope.server.uploadRequested = false
      overlay.show({text: 'Hochladen fehlgeschlagen, versuch\'s doch nochmal!', type: 'error'})

  $scope.test =
    imageSrc: null #photo source, b64 encoded string, either from phonegap or usermedia
  $scope.userMedia =
    videoAvailable: false #boolean to indicate whether videostream is ready
    imageAvailable: false #boolean to indicat whether ???
    videoBlob: null #blob reference for videostream from usermedia
  $scope.server =
    uploadRequested: false #boolean to lock upload
    fileName: '' #returnvalue from server, is the actual saved image name for email
    email: ''#email adress from input


  $scope.$watch 'test.imageSrc', ->
    return unless $scope.test.imageSrc
    uploadToServer({image: $scope.test.imageSrc, email: $scope.server.email})

  $scope.onUploadClick = (ev) ->
    console.log "uploadreq", $scope.server.uploadRequested
    return if $scope.server.uploadRequested || !$scope.test.imageSrc
    selfieNav.pushPage("html/email_modal.html", { animation : 'slide' })

  $scope.onEmailClick = ->
    return if $scope.server.uploadRequested
    #1. gucken ob gerade hochgeladne wird, wenn ja: button locken
    #2. wenn nicht hochgeladen dann datei mitshcicken
    if $scope.server.fileName
      opts =
        name: $scope.server.fileName
        email: $scope.server.email
    else
      opts =
        image: $scope.test.imageSrc
        name: $scope.server.fileName
        email: $scope.server.email
    sendToEmail(opts)

  $scope.onDestroyClick = ->
    $scope.test.imageSrc = null
    $scope.userMedia.imageAvailable = false
]
module.exports = MainCtrl
