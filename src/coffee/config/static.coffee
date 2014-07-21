data =
  serverIP: 'http://141.83.80.129'
  imageSrc: 'img/selfie.png'
  base64Regex: /^(?:data\:[^,]+,)?(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?$/
  phonegap:
    CameraDefaults: #phonegap defaults
      PictureSourceType:
        PHOTOLIBRARY: 0
        CAMERA: 1
        SAVEDPHOTOALBUM: 2
      DestinationType:
        DATA_URL: 0
        FILE_URI: 1
        NATIVE_URI: 2
      EncodingType:
        JPEG: 0
        PNG: 1
      MediaType:
        PICTURE: 0
        VIDEO: 1
        ALLMEDIA: 2
      Direction:
        BACK: 0
        FRONT: 1

data.phonegap.defaultOptions =
  quality: 50
  destinationType: data.phonegap.CameraDefaults.DestinationType.DATA_URL
  sourceType: data.phonegap.CameraDefaults.PictureSourceType.CAMERA
  encodingType: data.phonegap.CameraDefaults.EncodingType.PNG
  cameraDirection: data.phonegap.CameraDefaults.Direction.FRONT

module.exports = data
