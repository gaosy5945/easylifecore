<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	
	//��ȡǰ�˴���Ĳ���
	String accountType = DataConvert.toString(CurPage.getParameter("AccountType"));//������ת��Ϣ�Ƿ���ʾ�����
	if(accountType == null) accountType = "";
	String accountNo = DataConvert.toString(CurPage.getParameter("AccountNo"));//������ת��Ϣ�Ƿ���ʾ�����
	if(accountNo == null) accountNo = "";
	String currency = DataConvert.toString(CurPage.getParameter("Currency"));//������ת��Ϣ�Ƿ���ʾ�����
	if(currency == null) currency = "";
	String startDate = DataConvert.toString(CurPage.getParameter("StartDate"));//������ת��Ϣ�Ƿ���ʾ�����
	if(startDate == null) startDate = "";
	
	//String templateNo = CurPage.getParameter("TemplateNo");//ģ���
	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("QueryAccountDetailList", inputParameter, CurPage, request);
	
	ASDataObject doTemp = dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.workflow.web.QueryAccountDetailBusinessProcessor");
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.genHTMLObjectWindow("");
	
	String returnCode = dwTemp.CurPage.getAttribute("ReturnCode");
	if(returnCode==null||returnCode.length()==0)returnCode="";
	String returnMsg = dwTemp.CurPage.getAttribute("ReturnMsg");
	
	//��ť����
	String sButtons[][]={};
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script language=javascript>
	$(document).ready(function(){
		if("000000000000"!="<%=returnCode%>"&&("<%=returnCode%>").length>0){
			alert("��ѯʧ�ܣ�ʧ��ԭ��\n<%=returnMsg%>");
		}
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>