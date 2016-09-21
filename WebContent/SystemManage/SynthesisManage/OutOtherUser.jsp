
<%@page import="com.amarsoft.app.awe.config.role.action.UserLogin"%>
 <%@page import="com.amarsoft.app.check.OnLineUserCheck"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_ajax.jspf"%>
 <%
 		String SessionOut=CurPage.getAttribute("SessionOut");
 
  		OnLineUserCheck userCheck=new OnLineUserCheck(session,request,application,CurUser); 
 		Sqlca.commit();
	 	String[] sessionArray=SessionOut.split("@");
	 	userCheck.setSqlca(Sqlca);
	 	for(String sessionId:sessionArray){
	 		UserLogin.clearSession(application,request,session,sessionId);
	 		userCheck.checkOut(sessionId);	
	 	}  
		out.print("SUCCESS");
 %>
  <%@ include file="/Frame/resources/include/include_end_ajax.jspf"%>