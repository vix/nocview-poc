'use strict';
/* Controllers */
var app = angular.module('manocApp', [
    'ngRoute',
    'manocControllers',
    'manocServices',
]);
app.config(function($routeProvider) {
  $routeProvider
	.when('/building', {
	    templateUrl: 'static/partials/building/list.html', 
	    controller: 'BuildingListCtrl'
	})
	.when('/building/new', {
	    templateUrl: 'static/partials/building/edit.html', 
	    controller: 'BuildingEditCtrl'
	})
	.when('/building/:buildingId', {
	    templateUrl: 'static/partials/building/detail.html', 
	    controller: 'BuildingDetailCtrl'
	})
    	.when('/building/:buildingId/edit', {
	    templateUrl: 'static/partials/building/edit.html', 
	    controller: 'BuildingEditCtrl'
	})
	.otherwise({redirectTo: '/building'});
});
/*
app.config(function($httpProvider) {
    $httpProvider.responseInterceptors.push('securityInterceptor');
}).provider('securityInterceptor', function() {
    this.$get = function($location, $q) {
	return function(promise) {
            return promise.then(null, function(response) {
		if(response.status === 403 || response.status === 401) {
		    $location.path('/unauthorized');
		}
		return $q.reject(response);
            });
	};
    };
});
*/
