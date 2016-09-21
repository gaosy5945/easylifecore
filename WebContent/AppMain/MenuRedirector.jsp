<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
	//取系统名称
	String sImplementationName = CurConfig.getConfigure("ImplementationName");
	if (sImplementationName == null) sImplementationName = "";
	String PG_TITLE = sImplementationName; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = null; //默认的内容区标题
	String PG_CONTNET_TEXT = "";//默认的内容区文字
	String PG_LEFT_WIDTH = "0";//默认的treeview宽度
	
	String sTitle = CurPage.getParameter("Title");
	String sUrl = CurPage.getParameter("Url");
	String sParas = CurPage.getParameter("Paras");
	if(sParas == null) sParas = "";
%>
<%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
<%if(sUrl != null){%>
	AsControl.OpenView("/AppMain/MenuTabContainer.jsp", "Title=<%=sTitle%>&Url=<%=sUrl%>&Paras=<%=sParas%>", "right");
<%}%>
</script>
<%@ include file="/IncludeEnd.jsp"%>