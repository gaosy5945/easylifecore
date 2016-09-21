<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	String relativeObjectNo = CurPage.getParameter("RelativeObjectNo");
	String relativeObjectType = CurPage.getParameter("RelativeObjectType");	
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	if(relativeObjectNo == null) relativeObjectNo = "";
	if(relativeObjectType == null) relativeObjectType = "";
	if(transSerialNo == null) transSerialNo = "";
	if(transCode == null) transCode = "";
%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp","STATUS=2&OBJECTTYPE=jbo.acct.ACCT_TRANSACTION&OBJECTNO=<%=transSerialNo%>&ACCOUNTINDICATOR=07&RightType=ReadOnly","rightup","");
	AsControl.OpenView("/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp","STATUS=0&OBJECTTYPE=jbo.acct.ACCT_TRANSACTION&OBJECTNO=<%=transSerialNo%>&ACCOUNTINDICATOR=07","rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
