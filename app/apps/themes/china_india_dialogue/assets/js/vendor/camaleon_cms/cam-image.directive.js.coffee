do ->

  'use strict'
 
  camSrc = ->
    
    link = (scope, element, attr) ->
      propName = 'src'
      name = 'src'
      attr.$observe 'camSrc', (value) ->
        attr.$set name, theme_image_path(value)

        # if msie and propName
        #   element.prop propName, attr[name]
        return
    
    {
      priority: 99
      restrict: 'A'
      link: link
    }

  angular.module('camaleonCms').directive 'camSrc', camSrc

