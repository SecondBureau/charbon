do ->

  'use strict'
  
  Forms = ($filter, $http, $q, ENV) ->
    contact_form_endpoint = ENV.apiEndpoint + 'contactform'
    {
      getForm: (ThemeSlug, FormSlug) ->
        $http(
          url: contact_form_endpoint + '/' + ThemeSlug + '/forms/' + FormSlug
          cache: true
          method: 'GET').then (response) ->
            response
    }

  Forms.$inject = ['$filter', '$http', '$q', 'ENV']
  
  angular.module('cam.contactForm').factory 'Forms', Forms