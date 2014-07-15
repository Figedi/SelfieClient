'use strict'
require('../config/static')
require('../factories/overlay')

MainCtrl = ['$scope', '$http', 'Config', 'overlay', 'ngDialog', '$rootScope', ($scope, $http, Config, overlay, ngDialog, $rootScope) ->


  testForB64 = (image) -> Config.base64Regex.test(image)

  uploadToServer = (opts) ->
    $scope.uploadRequested = true
    httpConfig =
      method: 'POST'
      timeout: 20000 #20seconds
      url: "#{Config.serverIP}/upload"
      data: { b64: opts.image, email: opts.email }
    $http(httpConfig)
    .success (data, status, headers, config) ->
      overlay.show('Upload erfolgreich!')
      $scope.uploadRequested = false
    .error (data, status, headers, config) ->
      $scope.uploadRequested = false
      overlay.show({text: 'Upload fehlgeschlagen, versuch\'s doch nochmal!', type: 'error'})

  $scope.imageSrc = Config.imageSrc
  $scope.videoStream = '' #userMedia
  $scope.imageAvailable = false #userMedia
  $scope.uploadRequested = false
  $scope.dialogModel =
    email: ""

  $scope.onUploadClick = ->
    return if $scope.uploadRequested
    if (testForB64($scope.imageSrc))
      dialogPromise = ngDialog.openConfirm
        template: "html/email_modal.html"
        scope: $scope
      dialogPromise.then ->
        uploadToServer({image: $scope.imageSrc, email: $scope.dialogModel.email})
        $scope.dialogModel.email = ""
    else
      overlay.show({text: 'Kein Selfie gefunden! :(', type: 'error'})

  $scope.onDestroyClick = ->
    $scope.imageSrc = Config.imageSrc
    $scope.imageAvailable = false
]
module.exports = MainCtrl
