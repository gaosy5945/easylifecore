<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	--ҳ��˵��: �����������ҿ��ҳ��--
 */
 
	String UserID = CurPage.getParameter("UserID");
	if(UserID == null) UserID = "";
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">	
	myleft.width=320;
	AsControl.OpenView("/CustomerManage/MyOrgCustomerTree.jsp","UserID="+"<%=UserID%>","frameleft","");
	//AsControl.OpenView("/FrameCase/ExampleList.jsp","","frameright","");
</script>
<%@ include file="/IncludeEnd.jsp"%>