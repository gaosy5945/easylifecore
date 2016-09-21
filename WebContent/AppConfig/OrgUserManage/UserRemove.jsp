<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.awe.config.role.action.UserLogin"%> <%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	try{
		
	String sessionId=CurPage.getParameter("sessionId");
	String userId=CurPage.getParameter("userId");
	UserLogin.clearSession(application,request,session,sessionId);
 	SqlObject sqlObj=new SqlObject("update user_list set endtime=:endTime where sessionid=:sessionId and UserID=:userId and endtime is null");
 	sqlObj.setParameter("endTime",DateHelper.getDateTime());
 	sqlObj.setParameter("sessionId",sessionId);
 	sqlObj.setParameter("userId",userId);
 	Sqlca.executeSQL(sqlObj);
	out.print("SUCCESS");
	}catch(Exception e){
		out.print("FAIL");
		e.printStackTrace();
	}
%>

<%@ include file="/IncludeEndAJAX.jsp"%>