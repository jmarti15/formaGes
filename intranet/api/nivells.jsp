<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
	String sMtd = request.getMethod();
	String jsonString = ""; 

	if( sMtd.equals("GET")){						// db select
		/*
		SELECT Codi, Nom AS Nivel FROM Nivells
		*/
		String sSql = "SELECT Codi, Nom AS Nivel FROM Nivells";
		jsonString = sSelect2Json( sSql );
	} 
	else if( sMtd.equals("POST")){			// db insert
		/*
		INSERT INTO Nivells (nom) VALUES ("nivell4")
		*/
		String sNom = request.getParameter("nom");
		String sSql = "INSERT INTO Nivells (nom) VALUES (\""+sNom+"\")";
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
		String sCodi = request.getParameter("codi");
		String sNom = request.getParameter("nom");
		String sSql = "UPDATE Nivells SET Nom=\""+sNom+"\" WHERE Codi="+sCodi;		
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("DELETE")){		// db delete
		String sCodi = request.getParameter("codi");
		String sSql = "DELETE FROM Nivells WHERE Codi="+sCodi;
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