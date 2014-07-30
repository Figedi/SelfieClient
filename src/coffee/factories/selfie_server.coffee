require('../config/static')

selfieServer = ['$http', 'Config', ($http, Config) ->
  {
    upload: (opts) ->
      httpConfig =
        method: 'POST'
        url: "#{Config.serverIP}/upload"
        data: { b64: opts.image }
      $http(httpConfig)
    email: (opts) ->
      httpConfig =
        method: 'POST'
        url: "#{Config.serverIP}/email"
        data: { name: opts.name, email: opts.email }
      $http(httpConfig)
  }
]
module.exports = selfieServer
