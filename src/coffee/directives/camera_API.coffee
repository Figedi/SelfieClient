'use strict'
require('../config/static')
require('../factories/cordova_ready')
require('../factories/camera_data')
require('../factories/overlay')
###*
 * Directive for the image-Object. Initializes either a videostream and switches to
 * the usermedia module or uses the phonegap camera data-stream for image replacement
 *
 * @param {Function} cordovaReady Promise for the cordovaready event
 * @param {Object}   Config       Application Config Object
 * @param {Object}   cameraData   Shared Data between both directives
 *
 * @return {void}                 No explicit returnvalue needed
###
camera = ['cordovaReady', 'Config', 'cameraData', 'overlay', (cordovaReady, Config, cameraData, overlay) ->

  ##############################   Helper methods   ##############################
  navigator.getUserMedia = (navigator.getUserMedia ||
                          navigator.webkitGetUserMedia ||
                          navigator.mozGetUserMedia ||
                          navigator.msGetUserMedia)

  mediaOpts = (w,h) ->
    video:
      mandatory:
        "minWidth": w
        "maxWidth": w
        "minHeight": h
        "maxHeight": h
    audio: false

  getImageFromUserMedia = (element, scope) ->
    [ew,eh] = [element[0].width, element[0].height]
    video = document.querySelector('video')
    video.setAttribute('width', ew)
    video.setAttribute('height', eh)
    navigator.getUserMedia mediaOpts(ew,eh), onUsermediaSucc(scope), onUsermediaErr(scope)

  # first try to get usermedia picture
  onUsermediaSucc = (scope) ->
    (stream) ->
      cameraData.videoStream = stream
      cameraData.videoBlob = URL.createObjectURL stream
      scope.userMedia.videoBlob = URL.createObjectURL stream
      scope.userMedia.videoAvailable = true
      scope.$apply()
      cameraData.videoRequested = false

  #if usemedia fails, check if there is phonegap camera available
  #if not, do default image OR new image with special broken icon or whatsoever
  #videoRequested can be set to false already since usermedia is out of the picture
  onUsermediaErr = (scope) ->
    (err) ->
      console.log "err usermedia", err
      cameraData.videoRequested = false
      if navigator.camera
        getImageFromPhonegap(scope)
      else
        if err.name == 'DevicesNotFoundError'
          overlay.show({type: 'error', text: 'Keine Kamera verfügbar'})
        else
          overlay.show({type: 'error', text: 'Kamerafehler!'})
        scope.imageSrc = Config.imageSrc
        scope.userMedia.imageAvailable = false
        scope.$apply()

  getImageFromPhonegap = (scope) ->
    cordovaReady.ready().then ->
      navigator.camera.getPicture onPhonegapSucc(scope), onPhonegapErr, Config.phonegap.defaultOptions

  #if phonegap retrieved image successfully, replace it for preview in img container
  onPhonegapSucc = (scope) ->
    (data) ->
      console.log "success phonegap"
      scope.userMedia.imageAvailable = true
      scope.imageSrc = "data:image/png;base64,#{data}"
      scope.$apply()
      #cleanup cache
      cordovaReady.ready().then -> navigator.camera.cleanup((->), (->))
  #if phonegap failed again, fallback to default image (or again broken icon)
  onPhonegapErr = (err) ->
    toast.show({type: 'error', text: 'Kamerafehler :('})
    scope.imageSrc = Config.imageSrc
    scope.userMedia.imageAvailable = false
    scope.$apply()

  ##############################   Actual Directive   ############################
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'click', ->
        return if cameraData.videoRequested
        return if scope.uploadRequested
        scope.userMedia.imageAvailable = false #deactivate buttons after subsequent calls
        #todo: größere standardgröße wählen
        if navigator.getUserMedia
          cameraData.videoRequested = true
          #find the visible image (automatically visible by usermedia)
          getImageFromUserMedia(element, scope)
        else
          getImageFromPhonegap(scope)

    }
  ]
module.exports = camera
