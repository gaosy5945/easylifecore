<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
   String sSerialno = CurPage.getParameter("SerialNo");
	/* 
	页面说明： 通过数组定义生成Tab框架页面示例
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
		{"true", "申请详情", "/RiskClassify/ApplyInfo.jsp", "SerialNo="+sSerialno},
		{"true", "业务详情", "/FrameCase/widget/dw/ExampleInfo.jsp", "ExampleId=2013012300000001"},
		{"true", "客户信息", "/FrameCase/Layout/ExampleFrame.jsp", ""},
		{"true", "预警信息", "/FrameCase/Layout/ExampleFrame.jsp", ""},
		{"true", "催收记录", "/FrameCase/Layout/ExampleTab03.jsp", ""},
	};
	
	
%>

<%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>