 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String contractStatus = CurPage.getParameter("ContractStatus");
	if(contractStatus == null) contractStatus = "";
	String sRightType = CurPage.getParameter("sRightType");
	if(sRightType == null) sRightType = "";
	String openType = CurPage.getParameter("OpenType");//1登记，2查询
	if(openType == null) openType = "1";
/*
	页面说明: 示例上下联动框架页面
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/BusinessManage/GuarantyManage/CeilingGCManage.jsp","ContractType=020&ContractStatus=<%=contractStatus%>&sRightType=<%=sRightType%>&OpenType=<%=openType%>","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>