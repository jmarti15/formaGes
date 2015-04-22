'use strict';

//****************************************************************************
//http://pelablog.onicesistemas.es/validar-nif-nie-con-javascript/
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
