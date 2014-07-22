'use strict'
require('../config/static')
require('../factories/camera_data')
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
usermedia = ['Config', 'cameraData', (Config, cameraData) ->

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
        scope.videoBlob = null
        scope.videoAvailable = false

        scope.$apply()
        cameraData.videoRequested = false
  }
  ]
module.exports = usermedia
