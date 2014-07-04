'use strict'
config = require('./config/static.coffee')
factories = require('./factories/cordova_ready.coffee')
cameraFactory = require('./factories/camera_data.coffee')
directives = require('./directives/camera.coffee')
controllers = require('./controllers/main_ctrl.coffee')

app = angular.module 'selfieApp', ['onsen.directives']
app.config [ '$sceDelegateProvider', ($sceDelegateProvider) ->
  # add blob urls (for getUsermedia) to whitelist
  $sceDelegateProvider.resourceUrlWhitelist([
    'self',
    /^\s*(blob|https?):|data:image\//
  ])
]
app.constant 'Config', config.config
app.factory 'cordovaReady', factories.cordovaReady
app.factory 'cameraData', cameraFactory.cameraData
app.directive 'camera', directives.camera
app.directive 'usermedia', directives.usermedia
app.controller 'MainCtrl', controllers.MainCtrl



