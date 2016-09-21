<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String childUrl = CurPage.getParameter("ChildUrl");
	
	if(serialNo == null) serialNo = "";
	if(transSerialNo == null) transSerialNo = "";
	if(childUrl == null) childUrl = "";
%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("/CreditManage/CreditChange/SelectDuebillList.jsp","SerialNo=<%=serialNo%>","rightup","");
</script>
<%@ include file="/IncludeEnd.jsp"%>