<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
	/* 
	页面说明： 通过数组定义生成Tab框架页面
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
		{"true", "查询方案管理", "/AppConfig/QueryScheme/QuerySchemeFrame.jsp", ""},
		{"true", "高级", "/AppConfig/QueryScheme/JBOQueryDialog.jsp", ""},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>