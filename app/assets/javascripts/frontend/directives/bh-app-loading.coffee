do ->

  'use strict'
  
  bhAppLoading = ->

    link = (scope, element, attributes) ->
      scope.$watch 'categories', (data) ->
        if angular.isArray(scope.categories) and scope.categories.length > 0
          element.remove()
        return
      return

    {
      link: link
      restrict: 'C'
    }

  
  angular.module('bahnhof').directive 'bhAppLoading', bhAppLoading
