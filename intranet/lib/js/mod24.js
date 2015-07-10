'use strict';

var mod24 = angular.module('mod24', ['scrollable-table', 'ui.bootstrap']);

mod24.service('func', function() {
    this.keys = function(obj){
        return obj? Object.keys(angular.copy(obj)) : [];
    };
});

// Al Añadir:  pq mostri la data de la bbdd yyyy-MM-dd amb format dd/MM/yy
mod24.directive('datepickerPopup', function (dateFilter, datepickerPopupConfig) {
	return {
		restrict: 'A',
		priority: 1,
		require: 'ngModel',
		link: function(scope, element, attr, ngModel) {
	    	var dateFormat = attr.datepickerPopup || datepickerPopupConfig.datepickerPopup;
  			ngModel.$formatters.push(function (value) {
  				return dateFilter(value, dateFormat);
  			});
	    }
	};
});

mod24.controller('opcCtrl', function($scope, $http, $modal, func) {
	$scope.actualitza = function() {
		$scope.$broadcast("renderScrollableTable");
	};
	$scope.neteja = function() {
		if($scope.search){
			$scope.search='';
			$scope.$broadcast("renderScrollableTable");
		}
	};

	$scope.getData = function() {
		$http.get("api/cursos.jsp").success( function(data) {
		    $scope.data = data;
		    $scope.dataKeys = func.keys( $scope.data[0] );
		    $scope.filtered = $scope.data;
		    $scope.search = '';     // set the default search/filter term
		});
	};
	$scope.getData();

	$scope.detall = function(codi) {
		if(codi) {
			$http.get("api/cursos.jsp?codi="+codi).success( function(data) {
				$scope.mostraDetall(data);
			});
		} else {
			$scope.mostraDetall(null);
		}
	};

	$scope.mostraDetall = function(data) {
		var modalInstance = $modal.open({
			templateUrl: 'lib/curs.html',
			controller: 'detallCtrl',
			size: '',         // large: 'lg'    normal: ''     small: 'sm'
			resolve: {
			    dataDet: function () {
			        return data;
			    }
			}
		});
		modalInstance.result.then( function() {
			$scope.getData();
		}, function () {
			// cancel
		});
	};

});


mod24.controller('detallCtrl', function($scope, $http, $timeout, $modalInstance, dateFilter, func, dataDet) {
// dataDet:	mod/del			{...}
//						add					null
	$scope.data = dataDet;
	if(dataDet){
		$scope.codi = dataDet.Codi;
		$scope.nom = dataDet.Nom;
		$scope.tancat = $scope.data.Tancat == 1;		// Convertim int (bbdd) a boolean (checkbox)  
	} else {
		$scope.codi = '';
		$scope.nom = '';
	}
	
	$scope.delPremut = false;
	$scope.dangerMsg = '';

	
	// Data
	$scope.dataOpen = function($event) {
	    $event.preventDefault();
	    $event.stopPropagation();
	    $scope.opened = true;
	};
	$scope.dataKey = function(ev){
		ev.which = ev.which || ev.keyCode;
   		if( ev.which == 27) $scope.cancel();	//ESC
   		else {
   			var datEle = document.getElementById('Data');
   			var datLen = datEle.value.length;
   			if( datLen == 2 || datLen == 5 ){		// dd o dd/MM
   				// si acaben de prémer DEL, borrem també un altre caràcter
   				if( ev.which == 8 ) datEle.value = datEle.value.substring(0,datLen-1);
   				// si acaben d'entrar un nombre, afegim la /
   											else datEle.value = datEle.value + '/';
   			}
   		}
	};
	
	
	// Formacions
	$http.get("api/formacions.jsp").success( function(data) {
		$scope.formacions = data;
	});
	
	
	// Centres
	$http.get("api/centres.jsp?codi=combo").success( function(data) {
		$scope.centres = data;
	});
	
	
	// Posem el focus al final del camp
	$timeout( function() {
		$('#Nom').focus();
		var strLength= $scope.nom.length;
		$('#Nom')[0].setSelectionRange(strLength, strLength);
      }, 400);		// Esperem a que es renderitzi la finestra modal

	
	$scope.canvi = function(opc) {
		$scope.delPremut = false;
		$scope.dangerMsg = '';
		$scope.campErr=[];	// netegem els errors de camps obligatoris
		
		if( opc=='data' ){
			$scope.dataErr = !validaData( document.getElementById('Data').value );
			
		} else if( opc=='forma' ){
			// al onKeyUp encara no s'ha actualitzat el valor de data.CodFormacio
			var idxF = document.getElementById('CodFormacio').selectedIndex;
			$scope.data.CodFormacio = idxF===0 ? null : $scope.formacions[idxF-1].Codi;
			
		} else if( opc=='centre' ){
			// al onKeyUp encara no s'ha actualitzat el valor de data.CodCentre
			var idxC = document.getElementById('CodCentre').selectedIndex;
			$scope.data.CodCentre = idxC===0 ? null : $scope.centres[idxC-1].Codi;
		}
	};
	$scope.canviKU = function(ev, opc) {
    	var which = ev.which || ev.keyCode;
    	if( which != 13 && which != 9 ) $scope.canvi(opc);		// Ni RETURN ni TAB
	};

	
	$scope.validacions = function() {
		$scope.campErr = [];		// posarem a true pq s'apliqui la classe has-error (marca el camp en vermell) 
		
		if( $scope.dataErr ) {
			$scope.dangerMsg = "Fecha incorrecta...";
			$('#Data').focus();
			return false;
		}
		
		var campsOblig = ["Nom","Data","CodFormacio","CodCentre","Cupo"];
		var campDescri = function(camp){
			var alias =	{"Nom":"Nombre", "Data":"Fecha", "CodFormacio":"Formación", "CodCentre":"Centro", "Cupo":"Cupo"};
			return alias[camp];
		};
		$scope.msgErr = '';
		try {
			if( !$scope.data ){		// (al Añadir)  No han omplert cap camp
														// (Els elements de $scope.data es defineixen quan són informats, a l'inici $scope.data val null)
				$scope.dangerMsg = "Debe rellenar el campo: "+campDescri( campsOblig[0] );
				$scope.campErr[0] = true;
				$('#'+campsOblig[0]).focus();
				return false;
			} else {
				for( var i in campsOblig ){
					var camp = campsOblig[i];
					var valor = $scope.data[camp];
					if( !valor ){
						$scope.dangerMsg = "Debe rellenar el campo: "+campDescri( camp );
						$scope.campErr[i] = true;
						$('#'+camp).focus();
						return false;
					}
				}
			}
		}
		catch(err) {
			 $scope.msgErr = 'Error:' + err.message;
		}
		
		// Formategem la data per guardar-la a la bbdd
		//http://stackoverflow.com/questions/18061757/angular-js-and-html5-date-input-value-how-to-get-firefox-to-show-a-readable-d
		$scope.data.Data = dateFilter( $scope.data.Data, 'yyyy-MM-dd' );
		$scope.data.Tancat = $scope.tancat ? 1 : 0;		// Convertim boolean (checkbox) a int (bbdd)  

		if( $scope.data.CodOrganitzador === null ) $scope.data.CodOrganitzador = 0;		// L mentres no usem Organitzador... pq no peti
		
		return true;	//ok
	};
	
	
	$scope.add = function() {
		if( !$scope.validacions() ) return;
		
		$http.post("api/cursos.jsp", null, {"params":{"data": $scope.data}} )
		.success( function(data) {
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
		if( !$scope.validacions() ) return;

		$http.put("api/cursos.jsp", null, {"params":{"data": $scope.data}} )
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
// L   validar que no estigui en us
//		if( !$scope.validaDel() ) return;
		
		if( !$scope.delPremut ) {
			$scope.delPremut = true;
			$scope.dangerMsg = 'Pulse otra vez para eliminar';
		} else {
			$http.delete("api/cursos.jsp", {"params":{"codi": $scope.codi}})
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
    

    $scope.execDefault = function (ev) {
    	// Definim un botó per defecte
    	var which = ev.which || ev.keyCode;
    	if(which == 13 && ev.target.type != 'textarea') {		// al camp Coment pinto els Return's
        	if($scope.codi) $scope.mod();
        							else $scope.add();
       	}
    };

});
