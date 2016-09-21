<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "OneUserLogonInfo";//模板号
	//通过显示模版产生ASDataObject对象doTemp
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");

	//生成DataWindow对象	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly="1";
	dwTemp.genHTMLObjectWindow("LoginOne,10");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""}, 
	};
	%>
<%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
