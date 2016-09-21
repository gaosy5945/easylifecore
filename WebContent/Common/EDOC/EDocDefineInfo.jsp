<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String edocNo = CurPage.getParameter("EDocNo");
	if(edocNo == null) edocNo = "";

	String sTempletNo = "EdocDefineInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setColTips("", "测试");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(edocNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
$(document).ready(function(){
	if (getRowCount(0)==0){
		setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
		setItemValue(0,getRow(),"InputTime","<%=DateHelper.getToday()%>");
	}
	hideCol();
});

function SelectSuitOrg(){
	var selectedOrg = getItemValue(0,getRow(),"OrgList");
	if(typeof selectedOrg == "undefined") selectedOrg = "";
	var url = "/Common/EDOC/SelectOrgList.jsp";
	var param ="selectedOrg="+selectedOrg;
	var pageStyle = "dialogWidth=500px;dialogHeight=600px;center:yes;resizable:yes;scrollbars:auto;status:no;help:no";
	var returnValue = AsControl.PopView(url,param,pageStyle);
	if(returnValue ==null || typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_" || returnValue=="_NONE_"){
		return;
	}
	org = returnValue.split("@");
	setItemValue(0,getRow(),"OrgList",org[0]);
	setItemValue(0,getRow(),"OrgListName",org[1]);
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
