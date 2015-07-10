'use strict';

var mod26 = angular.module('mod26', ['scrollable-table', 'ui.bootstrap']);

mod26.service('func', function() {
    this.keys = function(obj){
        return obj? Object.keys(angular.copy(obj)) : [];
    };
});

// Al Añadir:  pq mostri la data de la bbdd yyyy-MM-dd amb format dd/MM/yy
mod26.directive('datepickerPopup', function (dateFilter, datepickerPopupConfig) {
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

mod26.controller('opcCtrl', function($scope, $http, $modal, func) {
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
		$http.get("api/descomptes.jsp").success( function(data) {
		    $scope.data = data;
		    $scope.dataKeys = func.keys( $scope.data[0] );
		    $scope.filtered = $scope.data;
		    $scope.search = '';     // set the default search/filter term
		});
	};
	$scope.getData();

	$scope.detall = function(codi) {
		if(codi) {
			$http.get("api/descomptes.jsp?codi="+codi).success( function(data) {
				$scope.mostraDetall(data);
			});
		} else {
			$scope.mostraDetall(null);
		}
	};

	$scope.mostraDetall = function(data) {
		var modalInstance = $modal.open({
			templateUrl: 'lib/descompte.html',
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


mod26.controller('detallCtrl', function($scope, $http, $timeout, $modalInstance, dateFilter, func, dataDet) {
// dataDet:	mod/del			{...}
//						add					null
	if(dataDet){
		$scope.codi = dataDet.Codi;
		$scope.nom = dataDet.Nom;
		$scope.data = dataDet;
	} else {
		$scope.codi = '';
		$scope.nom = '';
		$scope.data = {};
		$scope.data.DInicial = new Date();
	}
	$scope.tipDesc = $scope.data.NouImport &&  $scope.data.NouImport != '0' ? 'nimp' : 'perc';
	
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
   			var datEle = document.getElementById('DInicial');
   			var datLen = datEle.value.length;
   			if( datLen == 2 || datLen == 5 ){		// dd o dd/MM
   				// si acaben de prémer DEL, borrem també un altre caràcter
   				if( ev.which == 8 ) datEle.value = datEle.value.substring(0,datLen-1);
   				// si acaben d'entrar un nombre, afegim la /
   											else datEle.value = datEle.value + '/';
   			}
   		}
	};
	
		
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
			$scope.dataErr = !validaData( document.getElementById('DInicial').value );
			
		} else if( opc=='tipDesc' ){
			$scope.$apply();		// S'executaran els ng-disabled dels camps (per poder posar-hi el focus)
			if( $scope.tipDesc=='perc' ){
				$scope.data.NouImport = 0;
				$('#Percent').focus();
				$('#Percent')[0].setSelectionRange(0, 1);
			} else{
				$scope.data.Percent = 0;
				$('#NouImport').focus();
				$('#NouImport')[0].setSelectionRange(0, 1);
			}
		}
	};

	
	$scope.validacions = function() {
		$scope.campErr = [];		// posarem a true pq s'apliqui la classe has-error (marca el camp en vermell) 
		
		if( $scope.dataErr ) {
			$scope.dangerMsg = "Fecha incorrecta...";
			$('#DInicial').focus();
			return false;
		}
		
		var campsOblig = ["Nom","DInicial"];
		var campDescri = function(camp){
			var alias =	{"Nom":"Nombre", "DInicial":"F.Inicial", "Percent":"Porcentaje", "NouImport":"Nuevo Imp."};
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
		
		var sCamp = '';
		var iCamp = 0;
		if( $scope.tipDesc=='perc' ){
			if( !eval( $scope.data.Percent )){
				sCamp =  'Percent';
				iCamp = 2;
			}
		} else if( !eval( $scope.data.NouImport )){
				sCamp =  'NouImport';
				iCamp = 3;
			}
		if(sCamp){
			$scope.dangerMsg = "Debe rellenar el campo: "+campDescri( sCamp );
			$scope.campErr[iCamp] = true;
			$('#'+sCamp).focus();
			return false;
		}

		// Formategem la data per guardar-la a la bbdd
		//http://stackoverflow.com/questions/18061757/angular-js-and-html5-date-input-value-how-to-get-firefox-to-show-a-readable-d
		$scope.data.DInicial = dateFilter( $scope.data.DInicial, 'yyyy-MM-dd' );

		return true;	//ok
	};
	
	
	$scope.add = function() {
		if( !$scope.validacions() ) return;
		
		$http.post("api/descomptes.jsp", null, {"params":{"data": $scope.data}} )
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

		$http.put("api/descomptes.jsp", null, {"params":{"data": $scope.data}} )
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
			$http.delete("api/descomptes.jsp", {"params":{"codi": $scope.codi}})
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
