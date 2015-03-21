<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%!
public static String outLlista_() {
	String sHtml="";
	
	sHtml += "<div class=\"llista\"><form action=\"index.jsp\" method=\"post\" novalidate>";
	sHtml += "<table class=\"llista\" border=\"1\" style=\"width:100%\">";
	sHtml += "<thead><tr>";
sHtml += "<th>HEAD</th>";	
	sHtml += "</tr></thead>";
	
	return sHtml;
}
public static void outLlista() {
	%>
	prova1
	<%!	
}
public static void outLlista2() {
	%>
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
			</tbody>
		</table>
<%="sessionid="+request.getParameter("sessionid")%>	
		<input type="hidden" name="sessionid" value="<%=request.getParameter("sessionid")%>">
<%="opc="+request.getParameter("opc")%>	
		<input type="hidden" name="opc" value="<%= request.getParameter("opc") %>">
	</form></div>
	<%!
}

%>