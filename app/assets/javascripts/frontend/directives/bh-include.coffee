do ->

  bhInclude = ->

    template = (element, attributes) ->
      attributes.bhInclude

    link = (scope, element, attributes, controllers) ->
      vars = undefined
      key = undefined
      value = undefined
      vars = scope.bhIncludeParams()
      for key of vars
        `key = key`
        value = vars[key]
        scope[key] = value
      return

    {
      link: link
      restrict: 'A'
      transclude: true
      scope: 'bhIncludeParams': '&'
      templateUrl: template
      controller: [
        '$scope'
        ($scope) ->
          $scope.categories.then ->
            $scope.homePosts.then (response) ->
              console.log 'bhinclude search finished'
              console.log response.data
              return
            return
          return
      ]
    }

  'use strict'
  angular.module('bahnhof').directive 'bhInclude', bhInclude
  return
