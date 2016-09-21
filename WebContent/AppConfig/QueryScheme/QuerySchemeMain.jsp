<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "web定制查询";
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
	String PG_CONTNET_TEXT = "";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	//myleft.width=1;
	AsControl.OpenView("/AppConfig/QueryScheme/QuerySchemeTab.jsp","","right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>