<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%-- 页面说明: 加入我的客户上下页面--%>
<%
	String sCustomerID =  CurPage.getParameter("CustomerID"); 	
	%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	

	var sCustomerID = "<%=sCustomerID%>";
	AsControl.OpenView("/CustomerManage/MyCustomer/IndCustomer/JoinMyCustomerList.jsp","CustomerID="+sCustomerID,"rightup","");
	AsControl.OpenView("/FrameCase/ExampleList.jsp","","rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
