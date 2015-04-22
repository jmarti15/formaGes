"use strict";

var mod11 = angular.module('mod11', ['scrollable-table']);

mod11.controller('clientsCtrl', function($scope, $http) {
	// Definim la funció dins del controlador
	/// Ja ho carrega a l'inici
	
	$scope.actualitza = function() {
		$scope.$broadcast("renderScrollableTable");
	};
	$scope.neteja = function() {
		if($scope.search){
			$scope.search='';
			$scope.$broadcast("renderScrollableTable");
		}
	};
    $scope.keys = function(obj){
        return obj? Object.keys(angular.copy(obj)) : [];
    };

	$scope.getInscripcions = function() {
		$http.get("api/inscrip.jsp").success( function(data) {
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
