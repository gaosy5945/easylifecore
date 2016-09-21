<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
	/* 
	页面说明： 本页面用于ExampleTab.jsp中Tab标签页再打开tab时调用
	*/
	String sTabStrip[][] = {
		{"true", "List", "/FrameCase/widget/dw/ExampleList.jsp", ""},
		{"true", "Info", "/FrameCase/widget/dw/ExampleInfo.jsp", "ExampleId=2013012300000001"},
		{"true", "Frame_1", "/FrameCase/Layout/ExampleFrame.jsp", ""},
		{"true", "Frame_2", "/FrameCase/Layout/ExampleFrame.jsp", ""},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>