<%@page import="com.amarsoft.app.als.ui.function.FunctionWebTools"%>
<%@ page contentType="text/html; charset=GBK"%> 
<%@ include file="/Frame/resources/include/include_begin.jspf"%> 
<%@page import="com.amarsoft.app.als.sys.function.model.FunctionInstance"%>
<%
	FunctionInstance functionInstance=FunctionInstance.getFunctionInstance(CurPage, CurUser);
	String functionID = functionInstance.getFunction().getKeyString();
	String functionItemID =functionInstance.getCurFunctionItemID();
	String url = FunctionWebTools.getFunctionURL(functionInstance, functionItemID);
	String parameters = FunctionWebTools.getFunctionWebParameters(functionInstance, functionItemID);
	
	String functionName = functionInstance.getFunction().getString("FunctionName");
	String rightType = functionInstance.getFunction().getString("RightType");
	request.getRequestDispatcher(url).forward(request,response);
%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>