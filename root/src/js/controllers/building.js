manocControllers.controller('BuildingListCtrl', ['$scope', 'Building', '$location', function($scope, Building, $location) {
    $scope.buildings = Building.query();
    $scope.orderProp = 'name';

    $scope.editBuilding = function (buildingId) {
        $location.path('/building/' + buildingId + '/edit');
    };
    $scope.deleteBuilding = function (buildingId) {
        Building.delete({ id: buildingId });
	$scope.buildings = Building.query();

    };    
    $scope.createBuilding = function () {
        $location.path('/building/new/');
    };
}]);

manocControllers.controller('BuildingDetailCtrl', ['$scope', '$routeParams', 'Building',
function($scope, $routeParams, Building) {
    $scope.building = Building.get({'buildingId' : $routeParams.buildingId});
}]);

manocControllers.controller('BuildingEditCtrl', ['$scope', '$routeParams', 'Building', '$location',
    function ($scope, $routeParams, Building, $location) {

        // callback for ng-click 'save':
        $scope.save = function () {
	    $scope.building.$save();
	    $location.path('/building/');
        };

        // callback for ng-click 'cancel':
        $scope.cancel = function () {
	    $location.path('/building/');
        };

	if ($routeParams.buildingId ) {
	    $scope.building = Building.get({'buildingId' : $routeParams.buildingId});
	} else {
	    $scope.building = new Building();
	}

    }]);

