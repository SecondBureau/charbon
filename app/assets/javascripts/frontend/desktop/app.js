// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.services' is found in services.js
// 'starter.controllers' is found in controllers.js

/*!
 * Bahnhof Application for China India Dialogue
 * http://secondbureau.com
 * Copyright 2016 Second Bureau
 * Main Module
 * MIT License
 */

angular.module('bahnhof', ['ionic', 'bahnhof.config', 'angular-toArrayFilter', 'dc.endlessScroll', 'ui.bootstrap', 'angularSpinner', 'angular-flexslider'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if(window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if(window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }
  });
})

.config(function($stateProvider, $urlRouterProvider) {

  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  // Each state's controller can be found in controllers.js
  $stateProvider



    .state('home', {
      url: '/home',
      views: {
        '': {
          templateUrl: 'templates/desktop/home.html',
          controller: 'HomeCtrl'
        }
      }
    })
    
    .state('posts', {
      url: '/posts/:categorySlug',
      views: {
        '': {
          templateUrl: 'templates/desktop/posts.html',
          controller: 'PostsCtrl'
        }
      }
    })
    
    .state('post', {
      url: '/post/:postSlug',
      views: {
        '': {
          templateUrl: 'templates/desktop/post.html',
        }
      }
    })
    

  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/home');

});


