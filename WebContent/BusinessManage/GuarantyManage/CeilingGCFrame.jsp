 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String contractStatus = CurPage.getParameter("ContractStatus");
	if(contractStatus == null) contractStatus = "";
	String sRightType = CurPage.getParameter("sRightType");
	if(sRightType == null) sRightType = "";
	String openType = CurPage.getParameter("OpenType");//1�Ǽǣ�2��ѯ
	if(openType == null) openType = "1";
/*
	ҳ��˵��: ʾ�������������ҳ��
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/BusinessManage/GuarantyManage/CeilingGCManage.jsp","ContractType=020&ContractStatus=<%=contractStatus%>&sRightType=<%=sRightType%>&OpenType=<%=openType%>","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>