/*jslint node: true */
/*global angular */
"use strict";

var mod11 = angular.module('mod11', ['scrollable-table']);

mod11.controller('clientsCtrl', function($scope, $http) {
	// Definim la funció dins del controlador
	/// Ja ho carrega a l'inici
	
	$scope.actualitza = function() {
		$scope.$broadcast("renderScrollableTable");
	}
	$scope.neteja = function() {
		if($scope.search){
			$scope.search='';
			$scope.$broadcast("renderScrollableTable");
		}
	}
    $scope.keys = function(obj){
        return obj? Object.keys(angular.copy(obj)) : [];
    };

	$scope.getInscripcions = function() {
		$http.get("api/inscrip.jsp").success( function(data) {
/*
			$scope.visibleProjects = [{
		          facility: "Atlanta",
		          code: "C-RD34",
		          cost: 540000,
		          conditionRating: 52,
		          extent: 100,
		          planYear: 2014
		        }, {
		          facility: "Seattle",
		          code: "CRDm-4",
		          cost: 23000,
		          conditionRating: 40,
		          extent: 88,
		          planYear: 2014
		        }, {
		          facility: "Austin",
		          code: "GR-5",
		          cost: 1200000,
		          conditionRating: 92,
		          extent: 90,
		          planYear: 2014
		        }, {
		          facility: "Dayton",
		          code: "LY-7",
		          cost: 123000,
		          conditionRating: 71,
		          extent: 98,
		          planYear: 2014
		        }, {
		          facility: "Portland",
		          code: "Dm-4",
		          cost: 149000,
		          conditionRating: 89,
		          extent: 77,
		          planYear: 2014
		        }, {
		          facility: "Dallas",
		          code: "AW-3",
		          cost: 14000,
		          conditionRating: 89,
		          extent: 79,
		          planYear: 2014
		        }, {
		          facility: "Houston",
		          code: "Dm-4",
		          cost: 1100000,
		          conditionRating: 93,
		          extent: 79,
		          planYear: 2014
		        }, {
		          facility: "Boston",
		          code: "DD3",
		          cost: 1940000,
		          conditionRating: 86,
		          extent: 80,
		          planYear: 2015
		        }, {
		          facility: "New York",
		          code: "ER1",
		          cost: 910000,
		          conditionRating: 87,
		          extent: 82,
		          planYear: 2015
		        }];
*/
		    $scope.data = data;
		    $scope.dataKeys = $scope.keys( $scope.data[0] );
		    $scope.filtered = $scope.data;
		    $scope.search = '';     // set the default search/filter term
		});
	};
	/// A clients.html cridem: <div ng-init="descargaArchivo();">
	/// També ho podríem cridar aquí:
	$scope.getInscripcions();
});
