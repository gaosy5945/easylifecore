<%@page import="com.amarsoft.app.als.sys.function.model.FunctionInstance"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%>
<%
FunctionInstance functionInstance=FunctionInstance.getFunctionInstance(CurPage, CurUser);
String functionID = functionInstance.getFunction().getKeyString();
String functionItemID =functionInstance.getCurFunctionItemID();

String[][] pages = com.amarsoft.app.als.ui.function.FunctionWebTools.getUpDownPages(functionInstance, functionItemID);

%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
	AsControl.OpenView("<%=pages[0][1]%>","<%=pages[0][2]%>","rightup","");
	AsControl.OpenView("<%=pages[1][1]%>","<%=pages[1][2]%>","rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>