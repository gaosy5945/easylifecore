<%@page import="com.amarsoft.awe.res.AppManager"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:隐藏左侧区域的Main页面
	 */
	String PG_TITLE = AppManager.getAppName(CurPage.getParameter("AppID")); // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = null;// "&nbsp;&nbsp;子系统主页面&nbsp;&nbsp;"; //默认的内容区标题 为null则不显示标题行
	String PG_CONTNET_TEXT = "";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	AsControl.OpenView("/AppMain/CommonWelcome.jsp","","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>