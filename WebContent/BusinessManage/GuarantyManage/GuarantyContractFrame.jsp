 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
		String objectType =  CurPage.getParameter("ObjectType");
		String objectNo = CurPage.getParameter("ObjectNo");
		//String contractType = CurPage.getParameter("ContractType");
/*
	页面说明: 示例上下联动框架页面
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/BusinessManage/GuarantyManage/GuarantyContractList.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>