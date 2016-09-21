<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String customerID = CurPage.getParameter("CustomerID");
	if(serialNo == null) serialNo = "";
	if(transSerialNo == null) transSerialNo = "";
%>
<%-- 页面说明: 上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	

	AsControl.OpenView("/CreditManage/CreditApply/CommonApplierList.jsp","ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo=<%=serialNo%>&CustomerID=<%=customerID%>&TransSerialNo=<%=transSerialNo%>&ChangeFlag=Y","rightup","");
	AsControl.OpenView("/Blank.jsp","","rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
