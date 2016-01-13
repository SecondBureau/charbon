do ->

  'use strict'
  
  Categories = ($filter, $http, $q, ENV) ->
    categories = []
    categories_endpoint = ENV.apiEndpoint + 'categories'
    {
      all: ->
        if categories.length > 0
          $q (resolve, reject) ->
            resolve categories
            return
        else
          $http.get(categories_endpoint).then (response) ->
            categories = response.data
            categories
      get: (slug) ->
        $filter('filter')(categories, { slug: slug }, true)[0]

    }

  Categories.$inject = [
    '$filter'
    '$http'
    '$q'
    'ENV'
  ]
  
  angular.module('bahnhof').factory 'Categories', Categories

