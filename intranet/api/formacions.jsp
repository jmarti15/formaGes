<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
	String sMtd = request.getMethod();
	String jsonString = ""; 

	if( sMtd.equals("GET")){						// db select
		/*
		SELECT Codi, Nom AS Formación FROM Formacions
		*/
		String sSql = "SELECT Codi, Nom AS Formación FROM Formacions";
		jsonString = sSelect2Json( sSql, false );
	} 
	else if( sMtd.equals("POST")){			// db insert
		String sNom = request.getParameter("nom");
		/*
		INSERT INTO Formacions (Nom) VALUES ("Hipo N4")
		*/
		String sSql = "INSERT INTO Formacions (Nom) VALUES (\""+sNom+"\")";
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
		String sCodi = request.getParameter("codi");
		String sNom = request.getParameter("nom");
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
		String sCodi = request.getParameter("codi");
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