<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
/*
	Content: 上下框架页面, 上部打开验证规则列表
 */
 	String sDono = CurPage.getParameter("Dono");
	if(sDono == null) sDono = "";
%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">
	setDialogTitle("验证规则设置");
	AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/ValidateList.jsp","Dono=<%=sDono%>","rightup","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>