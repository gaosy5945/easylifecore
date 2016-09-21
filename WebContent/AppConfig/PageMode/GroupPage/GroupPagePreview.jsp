<%@page import="com.amarsoft.awe.ui.layout.grouppage.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%><%
	String sGroupID = CurPage.getParameter("GroupID");
	try{
		//预览页面使用单独的管理器
		GroupModelManager m = new PreviewManager(sGroupID,CurUser);
		//渲染
		out.println(m.getHtmlText());
	}catch(Exception e){
%>
	<script type="text/javascript">
		setDialogTitle("对不起！配置失败！");
	</script>
<%		throw e;
	}
%><%@ include file="/Frame/resources/include/include_end.jspf"%>