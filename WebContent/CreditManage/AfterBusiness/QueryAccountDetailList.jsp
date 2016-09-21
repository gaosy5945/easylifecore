<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	
	//获取前端传入的参数
	String accountType = DataConvert.toString(CurPage.getParameter("AccountType"));//流程流转信息是否显示意见列
	if(accountType == null) accountType = "";
	String accountNo = DataConvert.toString(CurPage.getParameter("AccountNo"));//流程流转信息是否显示意见列
	if(accountNo == null) accountNo = "";
	String currency = DataConvert.toString(CurPage.getParameter("Currency"));//流程流转信息是否显示意见列
	if(currency == null) currency = "";
	String startDate = DataConvert.toString(CurPage.getParameter("StartDate"));//流程流转信息是否显示意见列
	if(startDate == null) startDate = "";
	
	//String templateNo = CurPage.getParameter("TemplateNo");//模板号
	BusinessObject inputParameter = SystemHelper.getPageComponentParameters(CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("QueryAccountDetailList", inputParameter, CurPage, request);
	
	ASDataObject doTemp = dwTemp.getDataObject();
	doTemp.setBusinessProcess("com.amarsoft.app.workflow.web.QueryAccountDetailBusinessProcessor");
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.genHTMLObjectWindow("");
	
	String returnCode = dwTemp.CurPage.getAttribute("ReturnCode");
	if(returnCode==null||returnCode.length()==0)returnCode="";
	String returnMsg = dwTemp.CurPage.getAttribute("ReturnMsg");
	
	//按钮定义
	String sButtons[][]={};
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script language=javascript>
	$(document).ready(function(){
		if("000000000000"!="<%=returnCode%>"&&("<%=returnCode%>").length>0){
			alert("查询失败，失败原因：\n<%=returnMsg%>");
		}
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>