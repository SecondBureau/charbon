do ->

  'use strict'
  
  bhHolder = (preLoader) ->

    link = (scope, element, attrs) ->
      attrs.$observe 'bhHolder', ->
        if attrs.bhHolder != 'x'
          attrs.$set 'data-src', 'holder.js/' + attrs.bhHolder + '?auto=yes&bg=f4f7fb&fg=f4f7fb'
          Holder.run images: element[0]
          preLoader attrs.bhSrc, (->
            attrs.$set 'src', attrs.bhSrc
            return
          ), ->
            console.log 'chargement foiré'
            return
        return
      return

    {
      link: link
      priority: 200
      restrict: 'A'
    }

  
  angular.module('bahnhof').directive 'bhHolder', bhHolder
