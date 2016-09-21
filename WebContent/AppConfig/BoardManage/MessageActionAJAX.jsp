
<%@page import="com.amarsoft.app.als.sys.message.model.ChartManage"%> 
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

 
<%
response.setContentType("text/html;charset=GBK");
String fromUserid=CurPage.getParameter("FromUserID");
String toUserid=CurPage.getParameter("ToUserID");
String message=CurPage.getParameter("Message");
String action=CurPage.getParameter("action");
if(action==null) action="";
	ChartManage chartM=new ChartManage(application);
	String result="";
if(action.equals("put")){
	 result= chartM.putMessage(fromUserid, toUserid, message);
	out.print("消息发送成功!");
}else if(action.equals("get")){
	 result= chartM.getMessage(toUserid);
	 out.print(result);
}
%>
 

<%@ include file="/IncludeEndAJAX.jsp"%>