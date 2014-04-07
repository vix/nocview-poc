'use strict';

/* Controllers */
var app = angular.module('manocApp', [
    'ngRoute',
    'manocControllers'
]);

app.config(function($routeProvider) {
  $routeProvider
	.when('/building', {
	    templateUrl: 'static/partials/building/list.html', 
	    controller: 'BuildingListCtrl'
	})
	.when('/building/:buildingId', {
	    templateUrl: 'static/partials/building/detail.html', 
	    controller: 'BuildingDetailCtrl'
	})
	// .when('/login', {templateUrl: 'login.html', controller: 'LoginCtrl'})
	// .when('/logout', {templateUrl: 'login.html', controller: 'LogoutCtrl'})
	.otherwise({redirectTo: '/building'});
});


