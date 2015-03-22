<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="lib/js/mod11.js"></script>
 
 <div class="container" ng-app="mod11" ng-controller="clientsCtrl">
	<table class="llista table table-striped table-hover table-condensed">
		<thead><tr>
			<th ng-repeat="cap in caps" style="width: {{cap.size}}%;">{{cap.val}}</th>
		</tr></thead>
		<tbody>
			<tr ng-repeat="client in clientList">
				<td ng-repeat= "camp in client" style="width: {{camp.size}}%;">{{camp.val}}</td>
			</tr>
		</tbody>
	</table>	
  
   	<button ng-click="descargaArchivo()">Actualitzar</button>
</div>