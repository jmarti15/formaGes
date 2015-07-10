<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
	String sMtd = request.getMethod();
	String jsonString = ""; 
//System.out.println( "paramMap:"+request.getParameterMap() );		// log

	if( sMtd.equals("GET")){						// db select
		String sCodi = request.getParameter("codi");
		String sSql;
		if(sCodi==null) {								// per la taula
			/*
			SELECT Cu.Codi, Cu.Nom AS Nombre, Data AS Fecha, F.Nom AS Formación, Ce.Nom AS Centro, Cupo, 
				 CASE Tancat WHEN 0 THEN "No" ELSE "Sí" END AS Cerrado
			FROM Cursos Cu
			INNER JOIN Formacions F ON Cu.CodFormacio = F.Codi 
			INNER JOIN Centres Ce ON Cu.CodCentre = Ce.Codi
			*/
			sSql = "SELECT Cu.Codi, Cu.Nom AS Nombre, Data AS Fecha, F.Nom AS Formación, Ce.Nom AS Centro, Cupo, ";
			sSql += "CASE Tancat WHEN 0 THEN \"No\" ELSE \"Sí\" END AS Cerrado ";
			sSql += "FROM Cursos Cu ";
			sSql += "INNER JOIN Formacions F ON Cu.CodFormacio = F.Codi ";
			sSql += "INNER JOIN Centres Ce ON Cu.CodCentre = Ce.Codi";
			jsonString = sSelect2Json( sSql, false );
		} else {												// pel form
			/*
			SELECT * FROM Cursos WHERE Codi = 1
			*/
			sSql = "SELECT * FROM Cursos WHERE Codi="+sCodi;
			jsonString = sSelect2Json( sSql, true );
		}
	}
	else if( sMtd.equals("POST")){			// db insert
		String sData = request.getParameter("data");
		/*
		INSERT INTO Cursos (Nom, ..) VALUES ("Hipo N1 Bcn Jun15", ..)
		*/
		String sSql = sInsertQuery( "Cursos", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
		String sData = request.getParameter("data");
		/*
		UPDATE Cursos SET Nom="Hipo N1 Bcn Jun15", ... WHERE Codi=3
		*/
		String sSql = sUpdateQuery( "Cursos", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("DELETE")){		// db delete
		String sCodi = request.getParameter("codi");
		/*
		DELETE FROM Cursos WHERE Codi=6
		*/
		String sSql = "DELETE FROM Cursos WHERE Codi="+sCodi;
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