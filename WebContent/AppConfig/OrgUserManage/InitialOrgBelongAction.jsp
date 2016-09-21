<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.InitOrgBelong"%>


<html>
<head>
<title></title>
<%
	String sResult = "false" ;
	InitOrgBelong initOrgBelong = new InitOrgBelong() ;
	sResult = initOrgBelong.run(Sqlca)+"" ;
%>

<script language=javascript>
	self.returnValue = "<%=sResult%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
