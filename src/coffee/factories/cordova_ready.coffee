# promise wrapper to wait for initialization until device is ready
cordovaReady = ['$q', '$rootScope', '$document', ($q, $rootScope, $document) ->
  deferred = $q.defer()
  $document.bind('deviceready', -> $rootScope.$apply(deferred.resolve))
  ready: -> deferred.promise
]
module.exports = cordovaReady
