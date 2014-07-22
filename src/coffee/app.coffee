'use strict'
#constants
config = require('./config/static.coffee')
#factories
cordovaReady = require('./factories/cordova_ready.coffee')
cameraData = require('./factories/camera_data.coffee')
overlay = require('./factories/overlay.coffee')
server = require('./factories/selfie_server.coffee')
#directives
camera = require('./directives/camera_API.coffee')
canvas = require('./directives/canvas_screenshot.coffee')
#controllers
MainCtrl = require('./controllers/main_ctrl.coffee')

app = angular.module 'selfieApp', ['onsen.directives']
app.config [ '$sceDelegateProvider', ($sceDelegateProvider) ->
  # add blob urls (for getUsermedia) to whitelist
  $sceDelegateProvider.resourceUrlWhitelist([
    'self',
    /^\s*(blob|https?):|data:image\//
  ])
]
app.constant 'Config', config
app.factory 'cordovaReady', cordovaReady
app.factory 'cameraData', cameraData
app.factory 'overlay', overlay
app.factory 'Server', server
app.directive 'camera', camera
app.directive 'usermedia', canvas
app.controller 'MainCtrl', MainCtrl



