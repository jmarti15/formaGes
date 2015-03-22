<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!--
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular-sanitize.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.12.0/ui-bootstrap-tpls.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.13/angular-ui-router.min.js"></script>
-->
<!-- If you are not sure which module is missing, use the not minified angular.js which gives a readable error message -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.css"></link>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular-sanitize.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.12.0/ui-bootstrap-tpls.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.13/angular-ui-router.js"></script>

<script src="lib/js/mod11.js"></script>
 
 <div class="container" ng-app="mod11" ng-controller="clientsCtrl">
 	{{numLins}} ==> {{clientList}}
 
<!--
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
 -->	
	<button ng-click="descargaArchivo()">Actualitzar</button>
</div> 



<p>#################################</p>
<div id="inscrip_form" >
	<h2>Inscripciones</h2>
	<br>
	<%@ include file="compoLlista.jsp" %>
	
<br><br><br>
	<a href="api/xxx">xxx</a><br><a href="api/users">users</a>
	<div class="llista"><form action="index.jsp" method="post" novalidate>
		<table class="llista" border="1" style="width:100%">
			<thead>
				<tr>
					<th>Col1</th>
					<th>Col2</th>
					<th>Col3</th>
					<th> </th>				<!-- per alinear amb la barra d'scroll -->
		  		</tr>
			</thead>
	  		<tbody>
				<tr>
					<td><button name="inscrip" value="13" >Jill</button></td>
					<td>Smith</td>		
					<td>50</td>
				</tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson1</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson2</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson3</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson4</td><td>94</td></tr>
				<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
			</tbody>
		</table>
		<input type="hidden" name="sessionid" value="<%=request.getParameter("sessionid")%>">
		<input type="hidden" name="opc" value="<%= request.getParameter("opc") %>">
	</form></div>
	
</div>
<!--		
		<form name="entrar" action="index.jsp" method="post" onsubmit="encrypt();">		
			<input type="text" spellcheck="false" autocapitalize="off" autocorrect="off" placeholder="Usuario" name="user">
			<input type="password" placeholder="Contraseña" name="pass">
			<input type="hidden" name="passH">
			<input type="checkbox" id="recordar" name="recordar">
			<label for="recordar">Seguir conectado</label>
			<input type="submit" value="Entrar" name="login">
 		</form>
--> 		