<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	--ҳ��˵��: �ͻ��������ҿ��ҳ��--
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