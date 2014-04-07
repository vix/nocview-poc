var manocControllers = angular.module('manocControllers', []);

manocControllers.controller('TacticalViewCtrl', function($scope) {
});

manocControllers.controller('BuildingListCtrl', function($scope, $http) {
    $http.get('/api/building/').success(function(data) {
	$scope.buildings = data.list;
    });
    $scope.orderProp = 'name';
});

manocControllers.controller('BuildingDetailCtrl', ['$scope', '$routeParams', '$http',
 function($scope, $routeParams, $http) {
     $http.get('api/building/' + $routeParams.buildingId ).success(function(data) {
	 $scope.building = data.data;
     });
 }]);

