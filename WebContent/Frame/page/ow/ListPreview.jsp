<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
 if(CurConfig.getParameter("RunMode")!=null && CurConfig.getParameter("RunMode").equals("Development")){
	//�ǿ���ģʽ������Ԥ��
	String sTempletNo = CurPage.getParameter("DONO");//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "1";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {};
%><%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<%}%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>