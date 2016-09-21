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
<%-- 页面说明: 示例上下框架页面 --%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/CreditManage/CreditChange/ContractGuarantyChangeList.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&TransSerialNo=<%=transSerialNo%>&TransCode=<%=transCode%>&RelativeObjectNo=<%=relativeObjectNo%>&RelativeObjectType=<%=relativeObjectType%>&ChangeFlag=Y","rightup","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
