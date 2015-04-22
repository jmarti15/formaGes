<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
	String sMtd = request.getMethod();
	String jsonString = ""; 

	if( sMtd.equals("GET")){						// db select
///
		/*
		SELECT Codi, Nom AS Formación FROM Formacions
		
		SELECT Codi, Nom as Centro, Contacte as Contacto, Telef1 as "Teléfono 1", Telef2 as "Teléfono 2", Email as eMail, Adre as Dirección, 
			CP as "C.Postal", Prov as Provincia, Pobl as Población, Coment as Comentarios, NomAdmin as Administrador, NIFAdmin as "NIF admin."
		FROM Centres
		*/
		String sSql = "SELECT Codi, Nom AS Formación FROM Formacions";
		jsonString = sSelect2Json( sSql );
	} 
	else if( sMtd.equals("POST")){			// db insert
///
		String sNom = request.getParameter("nom");
///
		/*
		INSERT INTO Formacions (nom) VALUES ("Hipo N4")
		*/
		String sSql = "INSERT INTO Formacions (nom) VALUES (\""+sNom+"\")";
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
///
		String sCodi = request.getParameter("codi");
		String sNom = request.getParameter("nom");
///
		/*
		UPDATE Formacions SET Nom="LPF N3" WHERE Codi=3
		*/
		String sSql = "UPDATE Formacions SET Nom=\""+sNom+"\" WHERE Codi="+sCodi;		
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("DELETE")){		// db delete
///
		String sCodi = request.getParameter("codi");
///
		/*
		DELETE FROM Formacions WHERE Codi=6
		*/
		String sSql = "DELETE FROM Formacions WHERE Codi="+sCodi;
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
%>

<%=jsonString%>

<%
   response.setContentType("application/json");
%>