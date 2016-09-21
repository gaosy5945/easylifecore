<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例上下框架页面
	 */
	 String objectType =  CurPage.getParameter("ObjectType");
		String objectNo =  CurPage.getParameter("ObjectNo");
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	var param = "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>";
	AsControl.OpenView("/CreditManage/Other/RecordChangeList.jsp", param, "rightup","");
	AsControl.OpenView("/CreditManage/Other/RecordChangeDetail.jsp", param, "rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
