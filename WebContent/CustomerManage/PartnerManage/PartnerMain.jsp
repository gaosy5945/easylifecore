<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//取系统名称
	String sImplementationName = CurConfig.getConfigure("ImplementationName");
	if (sImplementationName == null) sImplementationName = "";

	/*
	页面说明:示例模块主页面
	*/
	String PG_TITLE = sImplementationName; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = null; //默认的内容区标题
	String PG_CONTNET_TEXT = "";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度
%>
<%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	AsControl.OpenComp("/CustomerManage/PartnerManage/ProjectQueryList.jsp","","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>