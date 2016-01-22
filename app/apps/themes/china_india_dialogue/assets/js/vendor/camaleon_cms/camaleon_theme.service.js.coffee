do ->

  'use strict'
  
  Theme = ($filter, $http, $q, ENV) ->
    themes_endpoint = ENV.apiEndpoint + 'themes'
    fields = []
    addField = (field) ->
      fields.push field
    {
      getField: (ThemeSlug, FieldSlug) ->
        $http(
          url: themes_endpoint + '/' + ThemeSlug + '/fields/' + FieldSlug
          method: 'GET').then (response) ->
          addField(response.data)
          response
    }

  Theme.$inject = ['$filter', '$http', '$q', 'ENV']
  
  angular.module('camaleonCms').factory 'Theme', Theme