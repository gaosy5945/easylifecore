<%@page import="com.amarsoft.awe.res.model.AppItem"%>
<%@page import="com.amarsoft.awe.res.AppManager"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	//获取每个子系统的个性化信息
	String sNewAppID =  CurPage.getParameter("AppID");
	if(sNewAppID == null ) sNewAppID = "";
	
	//CurARC.setAttribute("AppID", sNewAppID);
	
	String sAppName="欢迎",sDescribe="欢迎";
	AppItem appItem = AppManager.getAppItem(sNewAppID);
	sAppName = appItem.getDisplayName();
	sDescribe = appItem.getDescribe();
	if(sDescribe == null) sDescribe = "";
%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title>Welcome</title>
<style>
.welcommain{width:1024px; height:576px; position:absolute; top:50%; left:50%; margin-left:-512px; margin-top:-288px; background:#fff url(<%=sWebRootPath%>/AppMain/resources/images/CommonWelcome.jpg) no-repeat}
.wmtxtzone{ height:130px; width:450px; margin-top:290px; margin-left:270px;}
.wmtxtzone p{ line-height:18px; color:#6b6b6b; font-size:13.5px; margin-top:14px}
.wmtxt{ color:#063073; font-size:32px;font-style:italic; border-bottom:1px solid #fff; padding-bottom:10px;}
.wmtxt dd{ font-size:15px; display:inline; margin-left:5px; color:#50ad00; font-family:Arial, Helvetica, sans-serif; }
</style>
</head>
<body scroll="no" style="background-color: #fff;">
<div class="welcommain">
	<div class="wmtxtzone">
    	<div class="wmtxt"><%=sAppName%><dd></dd></div>
    	<p><%=sDescribe%></p>
    </div>
</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>