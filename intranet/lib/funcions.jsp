<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.security.MessageDigest"
	import = "java.util.*"
	import = "org.json.simple.*"
	import = "org.json.simple.parser.*"
    pageEncoding="UTF-8"%>
<%/* 		no usats:
	import="java.io.*"
	import="java.util.Date"
	import="java.text.SimpleDateFormat"
*/%>
<%@ include file="dbInit.jsp" %>
<%!
	public static String sUpdateQuery( String sTaula, String sData ){
	// Retorna una query del tipus UPDATE
	//UPDATE table_name   SET column1=value1,column2=value2,...   WHERE some_column=some_value;
	
		// sData		
		//		{"Codi":"3","Nom":"1","Contacte":"2","Telef1":"3","Telef2":"4","Email":"5","Adre":"6","CP":"7","Prov":"8","Pobl":"9","Coment":"0","NomAdmin":"0","NIFAdmin":"39702772B"}
		String sSql = "UPDATE " + sTaula + " SET ";
		String sWhere = "";
		
		Iterator iter = iJsonStr2Iter( sData );
		Map.Entry entry = (Map.Entry)iter.next();
		sWhere = " WHERE " + entry.getKey() + "=" + entry.getValue();
		
		while( iter.hasNext() ){
			entry = (Map.Entry)iter.next();
			sSql += entry.getKey() + "=\"" + entry.getValue() + "\"";
			if( iter.hasNext() ) sSql += ", ";
		}
		
		sSql += sWhere;
		return sSql;
	}

	
	public static String sInsertQuery( String sTaula, String sData ){
	// Retorna una query del tipus INSERT 
	//INSERT INTO table_name (column1,column2,column3,...) VALUES (value1,value2,value3,...);

		//++++ aKeys
		//++++		[Codi, Nom, Contacte, Telef1, Telef2, Email, Adre, CP, Prov, Pobl, Coment, NomAdmin, NIFAdmin]
		//	sData
		//++++  	{"Centro":"1","Contacto":"2","Teléfono 1":"3","Teléfono 2":"4","eMail":"5","Dirección":"6","C.Postal":"7","Provincia":"8","Población":"9","Comentarios":"0","Administrador":"00","NIF admin.":"000"}
		//		{"Nom":"Un punt de llum","Contacte":"Xus, Agnès i Mónica","Telef1":"666 12 23 34","Telef2":"777 123 456","Email":"llum@gmail.com","Adre":"Llevant, 2","CP":"08144","Prov":"Barcelona","Pobl":"Mediona","Coment":"Espai de trobada de Mediona","NomAdmin":"Xus","NIFAdmin":"39702772B"}

		String sSql = "INSERT INTO " + sTaula + " (";
		String sValues = ") VALUES (";

		Iterator iter = iJsonStr2Iter( sData );
		while(iter.hasNext()){
			Map.Entry entry = (Map.Entry)iter.next();
			sSql += entry.getKey();
			sValues += "\"" + entry.getValue() + "\"";
			if( iter.hasNext() ){
				sSql += ", ";
				sValues += ", ";
			}
		}

		sSql += sValues + ")";
		return sSql;
	}

	
	public static Iterator iJsonStr2Iter( String sData ){
	// Retorna un interador a partir d'un objecte json, per poder-lo recórrer (usat a sUpdateQuery i sInsertQuery) 
		JSONParser parser = new JSONParser();
		ContainerFactory containerFactory = new ContainerFactory(){
			public List creatArrayContainer() {
				return new LinkedList();
			}
			public Map createObjectContainer() {
				return new LinkedHashMap();
			}
		};
		Map json = null;
		try{
			json = (Map)parser.parse( sData, containerFactory );
		}
		catch( ParseException pe ){
			System.out.println( "iJsonStr2Iter error  [Position: " + pe.getPosition() + "]  " + pe );
		}
		Iterator iter = json.entrySet().iterator();
		return iter;
	}

	
	public static String sKeys2Json( String sSql ){
	// Retorna un array amb el nom dels camps d'una taula
	//	Param:  sSql = "SELECT * FROM Centres LIMIT 1";
	
		Connection conn = null;
		String jsonString = "";
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(dbUrl,dbUser,dbPass);
			if (conn != null) {
				Statement stmt = conn.createStatement(); 
				ResultSet res = stmt.executeQuery( sSql );
				ResultSetMetaData rsmd = res.getMetaData();
				int iNumCol = rsmd.getColumnCount();

				JSONArray jKeysDb = new JSONArray();
				for (int i = 1; i <= iNumCol; i++) {
					jKeysDb.add(rsmd.getColumnName(i));
				}
				jsonString = jKeysDb.toJSONString();

				res.close();
				stmt.close();
				conn.close();
			}
		} catch (Exception e) {
			System.out.println("\n\n funcions.sKeys2Json -Error : "+e.getLocalizedMessage().toString());
		}
		return jsonString;
	}

	
	public static int iExecQuery( String sSql ) {
	// Executa una query INSERT, UPDATE o DELETE i retorna el número de files modificades 

		Connection conn = null;
		String jsonString = "";
		int iNumRowsChanged = -1;
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(dbUrl,dbUser,dbPass);
			if (conn != null) {
				Statement stmt = conn.createStatement();
				iNumRowsChanged = stmt.executeUpdate( sSql );
			}
		} catch (Exception e) {
			System.out.println("\n\n funcions.sExecQuery -Error : "+e.getLocalizedMessage().toString());
		}
		return iNumRowsChanged;
	}
	
	
	public static String sSelect2Json( String sSql, boolean bUnSolResul ) {
	// Executa una query SELECT i retorna un json amb el resultat
	//  unSolResul:	T -->  la consulta només retorna 1 fila (retornem objecte)
	//							Ex:  SELECT * FROM Centres WHERE Codi=1  -->  {"Codi":"1", "Centro":"CentreA", "Contacto":"Xus", ... }
	//						F -->  varies files (retornem array d'objectes)
	//							Ex:  SELECT Codi, Nom FROM Formacions  -->  [{"Codi":"1","Nom":"Hipo N1"}, {"Codi":"2","Nom":"Hipo N2"}, ... ]
		Connection conn = null;
		String jsonString = "";
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(dbUrl,dbUser,dbPass);
			if (conn != null) {
				Statement stmt = conn.createStatement(); 
				ResultSet res = stmt.executeQuery( sSql );
	
				int iNumFil = 0;
				if (res.last()) {
					iNumFil = res.getRow();
					res.beforeFirst(); // not rs.first() because the rs.next() below will move on, missing the first element
				}
	
				ResultSetMetaData rsmd = res.getMetaData();
				int iNumCol = rsmd.getColumnCount();

				List  l = new LinkedList();
				Map m[] = new Map[iNumFil];
				int j = 0;
				while (res.next()) {
					m[j] = new LinkedHashMap();
					for (int i = 1; i <= iNumCol; i++) {
						m[j].put( rsmd.getColumnLabel(i), res.getString(rsmd.getColumnLabel(i)) );
					}
					l.add(m[j++]);
				}
				jsonString = bUnSolResul? JSONValue.toJSONString(m[0]) : JSONValue.toJSONString(l);
				res.close();
				stmt.close();
				conn.close();
			}
		} catch (Exception e) {
			System.out.println("\n\n funcions.sSelect2Json -Error : "+e.getLocalizedMessage().toString());
		}
		return jsonString;
	}

	
	public static int iNivellUsuari( String sUser ) {
		int iNivell = -1;
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(dbUrl,dbUser,dbPass);
			if (conn != null) {
				Statement stmt = conn.createStatement();
				ResultSet res = stmt.executeQuery( "SELECT nivell FROM Usuaris where nom='"+sUser+"'" );
				if( res.next() ) {
					iNivell = res.getInt("nivell");				
				}
				res.close();
				stmt.close();
				conn.close();
			}
		} catch (Exception e) {
			System.out.println("\n\niNivellUsuari -Error : "+e.getLocalizedMessage().toString());
		}
		return iNivell;
	}

	
	public static boolean acces(String sUser, String sPass, String sLlavor, Contenidor Nivell) {
/*
out.println( "User: "+request.getParameter("user")+"<br/>" );
out.println( "Psw: "+request.getParameter("pass")+"<br/>" );
out.println( "PswEnc: "+request.getParameter("passH")+"<br/>" );
*/
		boolean bAcces = false;
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(dbUrl,dbUser,dbPass);
			if (conn != null) {
//System.out.println("Conexión a base de datos " + url + " ... Ok");
				Statement stmt = conn.createStatement();
				ResultSet res = stmt.executeQuery( "SELECT psw, nivell FROM Usuaris where nom='"+sUser+"'" );
				if( res.next() ) {
					String sPsw  = res.getString("psw");
//System.out.println( "Psw_BD: "+sPsw );
					String sPswHash = sha256(sPsw+sLlavor);
//System.out.println( "Psw_H : "+sPswHash );
					bAcces = sPswHash.equals(sPass);
//System.out.println( "Pass  : "+sPass );
				}
				if( bAcces )
					Nivell.setInt( res.getInt("nivell") );
/*
				if(bAcces) {
System.out.println("Accés correcte: "+sUser);
				}
				else
System.out.println("Accés INcorrecte");
//					out.println("User/Psw incorrecte<br/>");
*/					
				res.close();
				stmt.close();
				conn.close(); 
			}
			
		} catch (Exception e) {
			System.out.println("\n\nacces -Error : "+e.getLocalizedMessage().toString());
		}
		return bAcces;
	}

	
	public static Cookie borraCookie( ) {
		// Borrem cookie
		Cookie unCookie = new Cookie("user", null);
		unCookie.setPath("/");
		unCookie.setMaxAge(0);
		return unCookie;
	}

	
	public static String sha256(String sPsw) {
		try{
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			// byte[] hash = digest.digest(sPsw.getBytes("UTF-8"));
			//   Equival a:
			digest.update(sPsw.getBytes("UTF-8"));
			byte[] hash = digest.digest();
		    
		  StringBuffer hexString = new StringBuffer();
		  for (int i = 0; i < hash.length; i++) {
				/*
		    String hex = Integer.toHexString(0xff & hash[i]);
		    if(hex.length() == 1) hexString.append('0');
		    hexString.append(hex);
					Equival a:
				*/
				hexString.append(Integer.toString((hash[i] & 0xff) + 0x100, 16).substring(1));
		  }
			return hexString.toString();
			
	  } catch(Exception ex){
	  	throw new RuntimeException(ex);
	  }
	}

	
	public static String getClientIpAddr(HttpServletRequest request) {
	  String ip = request.getHeader("X-Forwarded-For");
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
    	ip = request.getHeader("Proxy-Client-IP");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	  	ip = request.getHeader("WL-Proxy-Client-IP");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	  	ip = request.getHeader("HTTP_CLIENT_IP");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	  	ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	  	ip = request.getRemoteAddr();
	  }
	  return ip;
  }
	
	
	class Contenidor{
		private int i;
		
		public void setInt(int ii){
	        this.i=ii;    
		}
		public int getInt(){
	        return this.i;    
		}
	}
%>