do ->

  'use strict'
  
  Users = ($filter, $http, $q, ENV) ->
    users = []
    userIds = []
    users_endpoint = ENV.apiEndpoint + 'users'
    
    addUser = (user) ->
      if userIds.indexOf(user.id) == -1
        users.push user
        userIds.push user.id
      user
    
    {
      getById: (userId) ->
        
        user = $filter('filter')(users, { id: userId }, true)
        if user.length > 0
          $q (resolve, reject) ->
            resolve user[0]
            return
        else
          $http(
            url: users_endpoint + '/' + userId
            cache: true
            method: 'GET').then (response) ->
              addUser response.data.user
          , (response) ->
              console.log (userId + ' not found')
              '404'

    }

  Users.$inject = ['$filter', '$http', '$q', 'ENV']
  
  angular.module('bahnhof').factory 'Users', Users
