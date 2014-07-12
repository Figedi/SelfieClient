'use strict'
require('../config/static')
require('../factories/cordova_ready')
require('../factories/camera_data')
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
exports.camera = ['cordovaReady', 'Config', 'cameraData', (cordovaReady, Config, cameraData) ->

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
      console.log "success"
      cameraData.videoStream = stream
      cameraData.videoBlob = URL.createObjectURL stream
      scope.videoStream = URL.createObjectURL stream
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
      else #todo: toast instead of log
        console.log "No phonegap or usermedia available"
        scope.imageSrc = Config.imageSrc
        scope.imageAvailable = false
        scope.$apply()

  getImageFromPhonegap = (scope) ->
    cordovaReady.ready().then ->
          navigator.camera.getPicture onPhonegapSucc(scope), onPhonegapErr, Config.phonegap.defaultOptions

  #if phonegap retrieved image successfully, replace it for preview in img container
  onPhonegapSucc = (scope) ->
    (data) ->
      scope.imageAvailable = true
      scope.imageSrc = data
      scope.$apply()

  #if phonegap failed again, fallback to default image (or again broken icon)
  onPhonegapErr = (err) ->
    #todo: again: error with toast
    console.log "err phonegap", err
    scope.imageSrc = Config.imageSrc
    scope.imageAvailable = false
    scope.$apply()

  ##############################   Actual Directive   ############################
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'click', ->
        return if cameraData.videoRequested
        return if scope.uploadRequested
        cameraData.videoRequested = true
        scope.imageAvailable = false #deactivate buttons after subsequent calls

        #todo: größere standardgröße wählen
        if navigator.getUserMedia
          getImageFromUserMedia(element, scope)
        else
          getImageFromPhonegap(scope)

    }
  ]

###*
 * @todo use larger video/snapshot size
 * Directive for the video-Object. Once a videostream is established, clicking/tapping on the video-tag
 * results in a screenshot and image-replacement of the imgtag. Once this is done, it switches back to the
 * camera directive
 *
 * @param {Object} Config     Application Config Object
 * @param {Object} cameraData Shared Data between both directives
 *
 * @return {void}             No explicit returnvalue needed
###
exports.usermedia = ['Config', 'cameraData', (Config, cameraData) ->

  ##############################   Helper methods   ##############################
  canvas = document.createElement('canvas')
  context = canvas.getContext('2d')

  createSnapshot = (element) ->
    [ew,eh] = [element.width, element.height]
    canvas.width = ew
    canvas.height = eh
    context.drawImage(element, 0, 0, ew, eh)
    canvas.toDataURL('image/png')

  ##############################   Actual Directive   ############################
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'click', ->
        scope.imageSrc = createSnapshot(element[0])
        element[0].pause()
        #stop the streaming from camera
        if cameraData.videoStream
          cameraData.videoStream.stop()
          cameraData.videoStream = null
        scope.imageAvailable = true
        #remove scope reference, thus toggling the ngSHow/hide
        scope.videoStream = null
        scope.$apply()
        cameraData.videoRequested = false
  }
  ]
