<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	--页面说明: 客户分组左右框架页面--
 */
 
	String userID = CurComp.getParameter("UserID");
	if(userID == null) userID = "";
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">	
	myleft.width=320;
	AsControl.OpenView("/CustomerManage/MyCustomerTree.jsp","UserID="+"<%=userID%>","frameleft","");
	//AsControl.OpenView("/FrameCase/ExampleList.jsp","","frameright","");
</script>
<%@ include file="/IncludeEnd.jsp"%>