/*jslint node: true */
/*global angular */
"use strict";

var mod21 = angular.module('mod21', ['scrollable-table', 'ui.bootstrap']);

mod21.controller('nivellsCtrl', function($scope, $http, $modal) {
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

	$scope.getNivells = function() {
		$http.get("api/nivells.jsp").success( function(data) {
		    $scope.data = data;
		    $scope.dataKeys = $scope.keys( $scope.data[0] );
		    $scope.filtered = $scope.data;
		    $scope.search = '';     // set the default search/filter term
		});
	};
	/// A clients.html cridem: <div ng-init="descargaArchivo();">
	/// També ho podríem cridar aquí:
	$scope.getNivells();

/* ho cridem:																	rebem:				resolve:								rebem a nivellDetallCtrl:
			detall(dataLin.Codi)											(Codi)					return Codi						1
 			detall(dataLin)														(Codi)					return Codi						{"Codi":"1","Nivel":"Hipo N1"}
 			detall(dataLin.Codi, dataLin.Nivel) 			(Codi,Desc)		return [Codi,Desc]		["1","Hipo N1"] 
 */
	$scope.detall = function(dataLin) {
//		alert(Codi);
        var modalInstance = $modal.open({
            templateUrl: 'lib/nivell.html',
            controller: 'nivellDetallCtrl',
            size: '',         // large: 'lg'    normal: ''     small: 'sm'
            resolve: {
                nivLin: function () {
                    return dataLin;
                }
            }
        });
/*
        modalInstance.result.then(function (selectedItem) {
            $scope.selected = selectedItem;
        }, function () {
            $scope.selected = '';
        });
 */
	}
});

mod21.controller('nivellDetallCtrl', function($scope, $http, $timeout, $modalInstance, nivLin) {
																																																// {"Codi":"1","Nivel":"Hipo N1"}
	$scope.codNiv = nivLin.Codi;
	$scope.nomNiv = nivLin.Nivel;
	$scope.delPremut = false;

	$timeout(function() {
		$('#nomID').focus();
      }, 400);		// Esperem a que es renderitzi la finestra modal

	$scope.canvi = function() {
		$scope.delPremut = false;
	}

	$scope.add = function() {
/*
$http.post		// para insertar
$http.put		// para actualizar
$http.delete	// para eliminar
 */		
		$http.post("api/nivells.jsp",[]).success( function(data) {
			

///
	});
///
};
	
	$scope.mod = function() {
		$scope.delPremut = false;
///		
	}
	
	$scope.del = function() {
		if( !$scope.delPremut ) {
			$scope.delPremut = true;
		} else {
alert('Borrat!');
		}
	}
});
