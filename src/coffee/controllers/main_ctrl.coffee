'use strict'
require('../config/static')
require('../factories/overlay')

MainCtrl = ['$scope', '$http', 'Config', 'overlay', ($scope, $http, Config, overlay) ->


  testForB64 = -> Config.base64Regex.test $scope.imageSrc
  lastScale = 1
  $scope.imageSrc = Config.imageSrc
  $scope.videoStream = '' #userMedia
  $scope.imageAvailable = false #userMedia
  $scope.uploadRequested = false


  $scope.onUploadClick = ->
    return if $scope.uploadRequested
    if (testForB64())
      $scope.uploadRequested = true
      httpConfig =
        method: 'POST'
        timeout: 20000 #20seconds
        url: "#{Config.serverIP}/upload"
        data: { b64: $scope.imageSrc }

      $http(httpConfig)
      .success (data, status, headers, config) ->
        overlay.show('Upload erfolgreich!')
        $scope.uploadRequested = false
      .error (data, status, headers, config) ->
        $scope.uploadRequested = false
        overlay.show({text: 'Upload fehlgeschlagen, versuch\'s doch nochmal!', type: 'error'})
    else
      overlay.show({text: 'Kein Selfie gefunden! :(', type: 'error'})

  $scope.onDestroyClick = ->
    $scope.imageSrc = Config.imageSrc
    $scope.imageAvailable = false
]
module.exports = MainCtrl
