'use strict'
require('../config/static')
require('../factories/overlay')

MainCtrl = ['$scope', '$http', 'Config', 'overlay', 'ngDialog', '$rootScope', ($scope, $http, Config, overlay, ngDialog, $rootScope) ->


  testForB64 = (image) -> Config.base64Regex.test(image)

  uploadToServer = (opts) ->
    httpConfig =
      method: 'POST'
      timeout: 30000 #30seconds
      url: "#{Config.serverIP}/upload"
      data: { b64: opts.image, email: opts.email }
    $http(httpConfig)
    .success (data, status, headers, config) ->
      overlay.show('Vielen Dank für dein Selfie!')
      $scope.imageName = data.file.name
      console.log "error while uploading"
    .error (data, status, headers, config) ->
      $scope.imageName = ''
      console.log "error while uploading"

  sendToEmail = (opts) ->
    $scope.uploadRequested = true
    httpConfig =
      method: 'POST'
      url: "#{Config.serverIP}/email"
      data: { name: opts.name, email: opts.email }
    $http(httpConfig)
    .success (data, status, headers, config) ->
      overlay.show('Email erfolgreich gesendet!')
      console.log "success", data
      $scope.uploadRequested = false
    .error (data, status, headers, config) ->
      $scope.imageName = ''
      $scope.uploadRequested = false
      overlay.show({text: 'Hochladen fehlgeschlagen, versuch\'s doch nochmal!', type: 'error'})


  $scope.imageSrc = Config.imageSrc
  $scope.videoStream = '' #userMedia
  $scope.imageAvailable = false #userMedia
  $scope.uploadRequested = false
  $scope.imageName = ''
  $scope.dialogModel =
    email: ''

  $scope.$watch 'imageSrc', ->
    return unless testForB64($scope.imageSrc)
    uploadToServer({image: $scope.imageSrc, email: $scope.dialogModel.email})

  $scope.onUploadClick = ->
    return if $scope.uploadRequested
    if (testForB64($scope.imageSrc))
      dialogPromise = ngDialog.openConfirm
        template: "html/email_modal.html"
        scope: $scope
      dialogPromise.then ->
        sendToEmail({name: $scope.imageName, email: $scope.dialogModel.email})
        $scope.dialogModel.email = ""
    else
      overlay.show({text: 'Kein Selfie gefunden! :(', type: 'error'})

  $scope.onDestroyClick = ->
    $scope.imageSrc = Config.imageSrc
    $scope.imageAvailable = false
]
module.exports = MainCtrl
