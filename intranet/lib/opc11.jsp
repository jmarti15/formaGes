<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="inscrip_form" >
	<h2>Inscripciones</h2>
	<br>
	<%@ include file="compoLlista.jsp" %>
<br><br><br>
	
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