<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "OneUserLogonInfo";//ģ���
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");

	//����DataWindow����	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly="1";
	dwTemp.genHTMLObjectWindow("LoginOne,10");
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""}, 
	};
	%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
