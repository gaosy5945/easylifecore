<%@page import="com.amarsoft.app.als.process.action.GetApplyParams"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ�����¿��ҳ��
	 */
%>
<%
	String objectNo = CurPage.getParameter("ObjectNo");//��������
	if(StringX.isSpace(objectNo)) objectNo = "";
	String objectType = CurPage.getParameter("ObjectType");
	if(StringX.isSpace(objectType)) objectType = "";
	BizObject bo = GetApplyParams.getObjectParams(objectNo,objectType);
	String customerID = bo.getAttribute("CustomerID").getString();
	if(StringX.isSpace(customerID)) customerID = "";
%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	mytoptd.height = 400;
	AsControl.OpenView("/CustomerManage/UnionManage/UnionMemberlist.jsp","PackageNo=<%=objectNo%>&ObjectType=<%=objectType%>&CustomerID=<%=customerID%>&SourceType=APPLY","rightup","");
	AsControl.OpenView("/CreditManage/CreditApply/UGMemberApplyList.jsp","PackageNo=<%=objectNo%>&ObjectType=<%=objectType%>","rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>