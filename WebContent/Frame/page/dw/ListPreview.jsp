<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%if(CurConfig.getParameter("RunMode")!=null && CurConfig.getParameter("RunMode").equals("Development")){
	//非开发模式不允许预览
 %>
<%
	String sTempletNo = CurPage.getParameter("DONO");//模板号
	ASDataObject doTemp = new ASDataObject(sTempletNo);
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp,request);
	dwTemp.Style = "1";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	String sButtons[][] = {
		
	};
%>
<%@
include file="/Frame/resources/include/ui/include_list.jspf"%>
<%}%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
