###!
# Bahnhof Application for China India Dialogue
# http://secondbureau.com
# Copyright 2016 Second Bureau
# BahnhofCtrl Controller
# MIT License
###


do ->
  
  BahnhofCtrl = ($scope, $location, $stateParams, Categories) ->
    
    # jshint validthis: true
    # var vm = this;
    
    $scope.categories = []
    Categories.all().then (categories) ->
      $scope.categories = categories
      return

    $scope.isActive = (route) ->
      route == $location.path()
    
    return

  'use strict'
  angular.module('bahnhof').controller 'BahnhofCtrl', BahnhofCtrl
  return