'use strict'

###*
 # @ngdoc overview
 # @name gerritTellMeWhatToDoApp
 # @description
 # # gerritTellMeWhatToDoApp
 #
 # Main module of the application.
###
angular
  .module('gerritTellMeWhatToDoApp', [
    'ngAnimate',
    'ngAria',
    'ngCookies',
    'ngResource',
    'ngRoute'
  ])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

