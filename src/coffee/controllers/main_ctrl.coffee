'use strict'
require('../config/static')

exports.MainCtrl = ['$scope', '$http', 'Config', ($scope, $http, Config) ->

  testForB64 = -> Config.base64Regex.test $scope.imageSrc

  $scope.imageSrc = Config.imageSrc
  $scope.videoStream = ''
  $scope.imageAvailable = false

  $scope.onUploadClick = ->
    console.log "scope.imageSrc", $scope.imageSrc
    if testForB64()
      $http.post("#{Config.serverIP}/upload", { b64: $scope.imageSrc })
      .success (data, status, headers, config) ->
        console.log "it works"
      .error (data, status, headers, config) ->
        console.log "it doesnt work"
    else
      console.log "no b64 image"

  $scope.onDestroyClick = ->
    alert('Löschen nicht erfolgreich, bitte Raum 302 aufsuchen!')
]

