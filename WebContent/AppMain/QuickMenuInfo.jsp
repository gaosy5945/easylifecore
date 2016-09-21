<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<head><title>快捷链接详情</title></head>
<%
	String sQuickId = CurPage.getParameter("QuickId");
	String sMenuID = CurPage.getParameter("MenuID");
	String sMenuName = CurPage.getParameter("MenuName");
	if(sQuickId == null) sQuickId = "";
	if(sMenuID == null) sMenuID = "";
	if(sMenuName == null) sMenuName = "";

	ASObjectModel doTemp = new ASObjectModel("QuickMenuInfo");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style = "2";
	dwTemp.ReadOnly = "0";
	
	dwTemp.genHTMLObjectWindow(sQuickId);
	
	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
	
	sButtonPosition = "south";
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function init(){
		if("<%=sQuickId%>" == ""){
			setItemValue(0, 0, "QuickParams", "<%=sMenuID%>");
			setItemValue(0, 0, "MenuName", "<%=sMenuName%>");
			setItemValue(0, 0, "QuickName", "<%=sMenuName%>");
			setItemValue(0,getRow(0),"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(0),"INPUTORG","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(0),"INPUTTIME","<%=DateHelper.getBusinessTime()%>");
		}
	}
	function saveRecord(){
		setItemValue(0,getRow(0),"FORUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"UPDATEORG","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(0),"UPDATETIME","<%=DateHelper.getBusinessTime()%>");
		as_save("myiframe0","setReturn()");
	}
	
	function setReturn(){
		var sQuickId = getItemValue(0, 0, "QuickId");
		var sQuickName = getItemValue(0, 0, "QuickName");
		var sQuickParams = getItemValue(0, 0, "QuickParams");
		var sRemark = getItemValue(0, 0, "Remark");
		top.returnValue = sQuickId+"@"+sQuickName+"@"+sQuickParams+"@"+sRemark;
	}
	
	function selectMenu(){
		var sMenuName = getItemValue(0, 0, "MenuName");
		var sQuickName = getItemValue(0, 0, "QuickName");
		
		var sMenuId = getItemValue(0, 0, "QuickParams");
		var sParam = "SelectDialogUrl=/AppMain/SelectMenuDialog.jsp&SelectDialogTitle=菜单选择窗口";
		if(sMenuId) sParam += "&MenuId="+sMenuId;
		var sReturn = AsControl.PopPage("/Frame/page/tools/SelectDialog.jsp", sParam, "dialogWidth:350px;dialogHeight:400px;resizable:no;maximize:no;help:no;menubar:no;status:no;");
		if(!sReturn) return;
		if(sReturn == "_CLEAR_") sReturn = ["", ""];
		else sReturn = sReturn.split("@");
		setItemValue(0, 0, "QuickParams", sReturn[0]);
		setItemValue(0, 0, "MenuName", sReturn[1]);
		
		if(!sQuickName || sQuickName == sMenuName)
			setItemValue(0, 0, "QuickName", sReturn[1]);
	}
	init();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>