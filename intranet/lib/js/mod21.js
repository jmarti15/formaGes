"use strict";

var mod21 = angular.module('mod21', ['scrollable-table', 'ui.bootstrap']);

mod21.controller('formacionsCtrl', function($scope, $http, $modal) {
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

	$scope.getFormacions = function() {
		$http.get("api/formacions.jsp").success( function(data) {
		    $scope.data = data;
		    $scope.dataKeys = $scope.keys( $scope.data[0] );
		    $scope.filtered = $scope.data;
		    $scope.search = '';     // set the default search/filter term
		});
	};
	/// A clients.html cridem: <div ng-init="descargaArchivo();">
	/// També ho podríem cridar aquí:
	$scope.getFormacions();

	$scope.detall = function(dataLin) {
        var modalInstance = $modal.open({
            templateUrl: 'lib/formacio.html',
            controller: 'formacioDetallCtrl',
            size: '',         // large: 'lg'    normal: ''     small: 'sm'
            resolve: {
            	dataDet: function () {
                	return dataLin;
                }
            }
        });
        modalInstance.result.then( function() {
        	$scope.getFormacions();
        }, function () {
        	// cancel
        });
	};

});

mod21.controller('formacioDetallCtrl', function($scope, $http, $timeout, $modalInstance, dataDet) {
//dataDet:	{"Codi":"1","Formación":"Hipo N1"}			mod/del
//						null																				add
	if(dataDet){
		$scope.codi = dataDet.Codi;
		$scope.nom = dataDet.Formación;
	} else {
		$scope.cod = '';
		$scope.nom = '';
	}
	$scope.delPremut = false;
	$scope.dangerMsg = '';

	// Posem el focus al final del camp amb id="nomID"
	$timeout(function() {
		$('#nomID').focus();
		var strLength= $scope.nom.length;
		$('#nomID')[0].setSelectionRange(strLength, strLength);
      }, 400);		// Esperem a que es renderitzi la finestra modal

	$scope.canvi = function() {
		$scope.delPremut = false;
		$scope.dangerMsg = '';
	};

	$scope.add = function() {
		$http({
		    method: 'POST',
		    url: "api/formacions.jsp",
		    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
		    transformRequest: function(obj) {
		        var str = [];
		        for(var p in obj)
		        str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
		        return str.join("&");
		    },
		    data: {"nom":$scope.nom}
		}).success( function(data) {
			if(data.res > 0) {
				$modalInstance.close();
			} else {
				$scope.dangerMsg = "Error de Base de Datos...";
			}
		})
		.error( function () {
			$scope.dangerMsg = "Error de comunicaciones...";
		});
	};

	$scope.mod = function() {
		$scope.delPremut = false;

		$http.put( "api/formacions.jsp", null, {"params":{"codi": $scope.codi, "nom": $scope.nom}} )
		.success(function(data) {
			if(data.res > 0) {
				$modalInstance.close();
			} else {
				$scope.dangerMsg = "Error de Base de Datos...";
			}
		})
		.error( function () {
			$scope.dangerMsg = "Error de comunicaciones...";
		});
	};

	$scope.del = function() {
		if( !$scope.delPremut ) {
			$scope.delPremut = true;
			$scope.dangerMsg = 'Pulse otra vez para eliminar';
		} else {
			$http.delete( "api/formacions.jsp", {"params":{"codi": $scope.codi}} )
			.success(function(data) {
				if(data.res > 0) {
					$modalInstance.close();
				} else {
					$scope.dangerMsg = "Error de Base de Datos...";
				}
			})
			.error( function () {
				$scope.dangerMsg = "Error de comunicaciones...";
			});
		}
	};

    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };

    $scope.execDefault = function ($event) {
    	// Definim un botó per defecte
    	var which = $event.which || $event.keyCode;
       	if(which == 13) {
        	if($scope.codi) $scope.mod();
        							else $scope.add();
       	}
    };

});
