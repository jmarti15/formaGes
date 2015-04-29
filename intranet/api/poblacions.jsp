<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
	String sMtd = request.getMethod();
	String jsonString = ""; 
//System.out.println( "paramMap:"+request.getParameterMap() );		// log

	if( sMtd.equals("GET")){						// db select
		String sCodPos = request.getParameter("codpos");
		String sCodPobl = request.getParameter("codpobl");
		String sSql;
		if( sCodPos != null || sCodPobl != null ){
			/*
			SELECT Po.Codi, CodPos, Po.Nom as Pobl, Pr.Nom as Prov
			FROM Poblacions Po INNER JOIN Provincies Pr
			ON Po.CodProv = Pr.Codi
				WHERE CodPos = '01013'		// codpos
				WHERE Po.Codi = 35171		// codpobl
			*/
			sSql = "SELECT Po.Codi, CodPos, Po.Nom as Pobl, Pr.Nom as Prov ";
			sSql += "FROM Poblacions Po INNER JOIN Provincies Pr ";
			sSql += "ON Po.CodProv = Pr.Codi ";
			if( sCodPos != null ){
				sSql += "WHERE CodPos = '"+sCodPos+"'";
			} else if( sCodPobl != null ){
				sSql += "WHERE Po.Codi = "+sCodPobl;
			}
			jsonString = sSelect2Json( sSql, false );
		}
	}
%>

<%=jsonString%>

<%
   response.setContentType("application/json");
%>