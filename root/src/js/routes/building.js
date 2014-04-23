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
