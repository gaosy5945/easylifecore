<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
 if(CurConfig.getParameter("RunMode")!=null && CurConfig.getParameter("RunMode").equals("Development")){
	//�ǿ���ģʽ������Ԥ��
	String sTempletNo = CurPage.getParameter("DONO");//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {};
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%}%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>