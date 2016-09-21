<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%-- 页面说明: 示例上下框架页面 --%>
<%
	String orgID = CurPage.getParameter("OrgID");
	if(orgID == null || orgID == "undefined") orgID = "";

%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/Common/Configurator/Authorization/TeamList.jsp","OrgID=<%=orgID%>","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>