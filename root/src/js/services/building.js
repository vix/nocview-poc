var module = angular.module("manocServices", ["manocResource"]);
// building Resource
module.factory("Building", [ 'ManocResource', function ($resource) {
    return $resource("/api/building/:buildingId",  {
	'buildingId': '@id'
    });
}]);
