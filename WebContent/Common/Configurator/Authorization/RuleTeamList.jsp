<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%-- ҳ��˵��: ʾ�����¿��ҳ�� --%>
<%
	String orgID = CurPage.getParameter("OrgID");
	if(orgID == null || orgID == "undefined") orgID = "";

%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/Common/Configurator/Authorization/TeamList.jsp","OrgID=<%=orgID%>","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>