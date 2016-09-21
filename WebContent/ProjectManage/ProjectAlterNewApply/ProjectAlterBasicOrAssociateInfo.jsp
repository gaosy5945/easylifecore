<%@ include file="/IncludeBegin.jsp"%>
<%
  String sFunctionID=CurPage.getAttribute("FunctionID");

%>
<script type="text/javascript">	
AsCredit.openFunction("<%=sFunctionID%>", "", "","_self"); 
</script>	
<%@ include file="/IncludeEnd.jsp"%>