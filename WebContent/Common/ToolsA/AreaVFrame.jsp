<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		Content: 左右框架页面 ,行政区划
	 */
	String sAreaCode = CurPage.getParameter("AreaCode");
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">
	myleft.width=340;
	OpenPage("/Common/ToolsA/AreaCodeSelect.jsp?AreaCode=<%=sAreaCode%>","frameleft","");
	OpenPage("/Blank.jsp?TextToShow=请在左方列表中选择一项","frameright","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>