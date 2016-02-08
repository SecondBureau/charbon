do ->

  'use strict'
  
  bhChangeFontSize = ->

    link = (scope, element, attributes) ->
      
      element.on 'click', ->
        if attributes.bhChangeFontSize
          e = angular.element(attributes.bhChangeFontSize);
        else
          e = element
        matches = e.css('font-size').match(/([0-9.]+)([a-z%]+)/)
        if matches
          e.css('font-size', Number(matches[1]) + Number(attributes.increment) + matches[2]);
      
      return

    {
      link: link
      restrict: 'A'
    }

  
  angular.module('bahnhof').directive 'bhChangeFontSize', bhChangeFontSize
