<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 上下联动框架页面
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">
	mytoptd.height = "200";
	AsControl.OpenView("/Common/SecurityAudit/UserLogonWelcomeList.jsp","","rightup","");
	AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的用户信息!","rightdown","");
</script>
<%@ include file="/IncludeEnd.jsp"%>