<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular-sanitize.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.12.0/ui-bootstrap-tpls.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.13/angular-ui-router.min.js"></script>

<!-- If you are not sure which module is missing, use the not minified angular.js which gives a readable error message -->
<!--
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.css"></link>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular-sanitize.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.12.0/ui-bootstrap-tpls.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.13/angular-ui-router.js"></script>
-->

<script src="lib/js/mod11.js"></script>

<div class="container" ng-app="mod11" ng-controller="clientsCtrl">

	<table class="table table-striped table-hover table-condensed" style="table-layout:fixed; margin-bottom: 0px;">
		<thead><tr>
			<td>A</td>
			<td>B</td>
			<td>C</td>
			<td style="width: 14px;"></td>
		</tr></thead>
	</table>	
	<div style="overflow-y: auto; height: 200px;">
		<table class="table table-striped table-hover table-condensed" class="table table-condensed"  style="table-layout:fixed">
			<tbody>
				<tr ng-repeat="client in clientList">
					<td>{{client.label}}</td>
					<td>{{client.value}}</td>
					<td>{{client.id}}</td>
				</tr>
			</tbody>
		</table>	
	</div>
	
	<button ng-click="descargaArchivo()">Actualitzar</button>
</div> 
