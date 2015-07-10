'use strict';

//****************************************************************************
//	http://www.niteshluharuka.com/2012/08/simple-date-validation-using-regex-in-javascript/
//****************************************************************************

function validaData(data) {
	if( !data ) return true;
	//		 	     dd            /   mm          /   yy
	var re = /([0-3]\d)\/([0-1]\d)\/(\d\d)/;
	if( re.test(data)){
		var tokens = data.split('/');
		var dd = parseInt(tokens[0], 10);
	    var mm = parseInt(tokens[1], 10);
	    var yy = parseInt(tokens[2], 10);
		var dayobj = new Date( yy, mm-1, dd );
		if ((dayobj.getDate()==dd) && (dayobj.getMonth()+1==mm) && (dayobj.getFullYear().toString().substr(2,2)==yy)) return true;
	}
	return false;
}

//****************************************************************************
//	https://sites.google.com/site/dwebtodojs/aprendemos-con-ejemplos/6-ejemplo-javascript-formularios-validacion-longitud-email-etc-expresiones-regulares
//****************************************************************************

function validarCodPos(cp) {
	if( !cp ) return true;
	var re = /(^([0-9]{5,5})|^)$/;
    return re.test(cp);
}

//****************************************************************************
//	http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
//****************************************************************************

function validateEmail(email) {
	if( !email ) return true;
    var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    return re.test(email);
}

//****************************************************************************
//	http://pelablog.onicesistemas.es/validar-nif-nie-con-javascript/
//****************************************************************************

function validaNifNie(value) {
	if( !value ) return true;
	if (validaNif(value) === false) {
		if (validaNie(value) === false) {
			return false;
		}
	}
	return true;
}

function validaNif(value) {
	value = value.toUpperCase();
	
	// Basic format test
	if (!value.match('((^[A-Z]{1}[0-9]{7}[A-Z0-9]{1}$|^[T]{1}[A-Z0-9]{8}$)|^[0-9]{8}[A-Z]{1}$)')) {
		return false;
	}
	
	// Test NIF
	if (/^[0-9]{8}[A-Z]{1}$/.test(value)) {
		return ("TRWAGMYFPDXBNJZSQVHLCKE".charAt(value.substring(8, 0) % 23) === value.charAt(8));
	}
	// Test specials NIF (starts with K, L or M)
	if (/^[KLM]{1}/.test(value)) {
		return (value[8] === String.fromCharCode(64));
	}
	
	return false;
}

function validaNie(value) {
	value = value.toUpperCase();
	
	// Basic format test
	if (!value.match('((^[A-Z]{1}[0-9]{7}[A-Z0-9]{1}$|^[T]{1}[A-Z0-9]{8}$)|^[0-9]{8}[A-Z]{1}$)')) {
		return false;
	}
	
	// Test NIE
	//T
	if (/^[T]{1}/.test(value)) {
		return (value[8] === /^[T]{1}[A-Z0-9]{8}$/.test(value));
	}
	
	//XYZ
	if (/^[XYZ]{1}/.test(value)) {
		return (
			value[8] === "TRWAGMYFPDXBNJZSQVHLCKE".charAt(
				value.replace('X', '0')
				.replace('Y', '1')
				.replace('Z', '2')
				.substring(0, 8) % 23
			)
		);
	}
	
	return false;
}
