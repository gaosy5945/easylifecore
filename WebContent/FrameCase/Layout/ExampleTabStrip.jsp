<%-- <%@page import="com.amarsoft.awe.ui.layout.grouppage.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
include file="/Frame/resources/include/include_begin.jspf"%><%
 	/* 
 		页面说明： 通过组合页面配置定义生成Tab/Strip页面示例
 	*/
 	GroupModelManager m = new GroupModelManager("DemoTab",CurUser);
	m.setParameter("0020","SerialNo=2010042600000002");

	String _sView = m.getViewType();
	String sTabStrip[][] = m.getItemArray();
%><%@ include file="/Resources/CodeParts/TabStrip01.jsp"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%> --%>

<%@page import="com.amarsoft.awe.ui.layout.grouppage.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
include file="/Frame/resources/include/include_begin.jspf"%><%
 	GroupModelManager m = new GroupModelManager("DemoStrip",CurUser);
	m.setParameter("0020","SerialNo=2010042600000002");
	
	out.println(m.getHtmlText());
%><%@ include file="/Frame/resources/include/include_end.jspf"%>