<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
 if(CurConfig.getParameter("RunMode")!=null && CurConfig.getParameter("RunMode").equals("Development")){
	//非开发模式不允许预览
	String sTempletNo = CurPage.getParameter("DONO");//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "1";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {};
%><%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%}%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>