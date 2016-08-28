

do ->
  'use strict'
  
  SubscriptionFormCtrl = ($scope, $http, ENV, $location) ->
    endpoint = ENV.apiEndpoint + 'subscriptionform'
    
    vm = this
    vm.submitted = false
    
    vm.submit = -> 
      vm.submitted = true
      vm.sending = true
      data = 
        subscriberName: vm.subscriberName
        subscriberEmail: vm.subscriberEmail

       
       $http(
         url: endpoint
         method: 'POST'
         data:
           data: data)
        
        .then (response) -> 
          vm.sending = false
          vm.message_submitted = "Your subscription has been received. Thank you !"
        , (response) ->
          vm.sending = false
          vm.message_submitted = "Sorry. An error occured. Please try again."
        
      
    return
    
  SubscriptionFormCtrl.$inject = ['$scope', '$http', 'ENV', '$location']
  angular.module('bahnhof').controller 'SubscriptionFormCtrl', SubscriptionFormCtrl