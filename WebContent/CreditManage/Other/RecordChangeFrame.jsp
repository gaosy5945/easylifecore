<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ�����¿��ҳ��
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
