<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String serialNo = CurPage.getParameter("DBSerialNo");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	if(serialNo == null) serialNo = "";
	if(transSerialNo == null) transSerialNo = "";
%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/CreditManage/CreditChange/ChangeAccountInfo.jsp","STATUS=2&OBJECTTYPE=jbo.acct.ACCT_TRANSACTION&OBJECTNO=<%=transSerialNo%>&ACCOUNTINDICATOR=01&RightType=ReadOnly","rightup","");
	AsControl.OpenView("/CreditManage/CreditChange/ChangeAccountInfo.jsp","STATUS=0&OBJECTTYPE=jbo.acct.ACCT_TRANSACTION&OBJECTNO=<%=transSerialNo%>&ACCOUNTINDICATOR=01","rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
