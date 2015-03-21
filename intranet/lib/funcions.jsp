<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.security.MessageDigest"
    pageEncoding="UTF-8"%>
<%/* 		no usats:
	import="java.io.*"
	import="java.util.Date"
	import="java.text.SimpleDateFormat"
*/%>
<%@ include file="dbInit.jsp" %>
<%!
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