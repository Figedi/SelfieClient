'use strict'
require('../config/static')

MainCtrl = ['$scope', '$http', 'Config', 'overlay', ($scope, $http, Config, overlay) ->


  testForB64 = -> Config.base64Regex.test $scope.imageSrc
  lastScale = 1
  $scope.imageSrc = Config.imageSrc
  $scope.videoStream = '' #userMedia
  $scope.imageAvailable = false #userMedia
  $scope.uploadRequested = false

  $scope.onTestClick = -> overlay.show({text: "logic"})

  $scope.onUploadClick = ->
    console.log "scope.imageSrc", $scope.imageSrc
    return if $scope.uploadRequested
    if testForB64()
      $scope.uploadRequested = true
      httpConfig =
        method: 'POST'
        timeout: 20000 #20seconds
        url: "#{Config.serverIP}/upload"
        data: { b64: $scope.imageSrc }

      $http(httpConfig)
      .success (data, status, headers, config) ->
        console.log "it works"
        $scope.uploadRequested = false
      .error (data, status, headers, config) ->
        $scope.uploadRequested = false
        console.log "it doesnt work"
    else
      console.log "no b64 image"

  $scope.onDestroyClick = ->
    $scope.imageSrc = Config.imageSrc
    $scope.imageAvailable = false
]
module.exports = MainCtrl
