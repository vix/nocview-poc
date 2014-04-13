'use strict';
var service = angular.module("apiServices", ["ngResource"]);

var dbicApiDataTransformer = function ($http) {
    return $http.defaults.transformResponse.concat([
        function (data, headersGetter) {
            var result = data.data;
            result.success = data.success;
            return result;
        }
    ])
};

// building Resource
service.factory("Building", [ '$resource', '$http', function ($resource, $http) {
    return $resource("/api/building/:buildingId",  {
	'buildingId': '@id'
    }, {
       'query':  {method:'GET', isArray: true, transformResponse: dbicApiDataTransformer($http)  },
       'get':  {method:'GET', transformResponse: dbicApiDataTransformer($http)  }
    });
}]);
