do ->

  'use strict'
  
  preLoader = ->
    (url, successCallback, errorCallback) ->
      #Thank you Adriaan for this little snippet: http://www.bennadel.com/members/11887-adriaan.htm
      angular.element(new Image).bind('load', ->
        successCallback()
        return
      ).bind('error', ->
        errorCallback()
        return
      ).attr 'src', url
      return

  
  angular.module('bahnhof').factory 'preLoader', preLoader

