 <%@page import="com.amarsoft.app.als.sys.function.model.FunctionInstance"%>
 <%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
 	FunctionInstance functionInstance=FunctionInstance.getFunctionInstance(CurPage, CurUser);
	String functionID = functionInstance.getFunction().getKeyString();
	String functionItemID =functionInstance.getCurFunctionItemID();
	
	String[][] pages = FunctionWebTools.getLeftRightPages(functionInstance, functionItemID);
	
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<script type="text/javascript">	
<%
//打印功能组件公共参数，以方便获取信息
//out.print(FunctionWebTools.printJSFunctionParameter(functionInstance,CurPage));
%>
	AsControl.OpenView("<%=pages[0][1]%>","<%=pages[0][2]%>","frameleft","");
	AsControl.OpenView("<%=pages[1][1]%>","<%=pages[1][2]%>","frameright","");
</script>
<%@ include file="/IncludeEnd.jsp"%>