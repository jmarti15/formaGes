<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
	String sMtd = request.getMethod();
	String jsonString = ""; 

	if( sMtd.equals("GET")){						// db select
		/*
		SELECT Codi, Nom AS "Método de captación" FROM MetodesCapt
		*/
		String sSql = "SELECT Codi, Nom AS \"Método de captación\" FROM MetodesCapt";
		jsonString = sSelect2Json( sSql, false );
	} 
	else if( sMtd.equals("POST")){			// db insert
		String sNom = request.getParameter("nom");
		/*
		INSERT INTO MetodesCapt (Nom) VALUES ("Facebook")
		*/
		String sSql = "INSERT INTO MetodesCapt (Nom) VALUES (\""+sNom+"\")";
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
		String sCodi = request.getParameter("codi");
		String sNom = request.getParameter("nom");
		/*
		UPDATE MetodesCapt SET Nom="LPF N3" WHERE Codi=3
		*/
		String sSql = "UPDATE MetodesCapt SET Nom=\""+sNom+"\" WHERE Codi="+sCodi;		
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("DELETE")){		// db delete
		String sCodi = request.getParameter("codi");
		/*
		DELETE FROM MetodesCapt WHERE Codi=6
		*/
		String sSql = "DELETE FROM MetodesCapt WHERE Codi="+sCodi;
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