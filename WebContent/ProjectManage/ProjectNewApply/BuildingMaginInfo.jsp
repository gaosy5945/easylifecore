<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String projectSerialNo = CurPage.getParameter("SerialNo");
	if(projectSerialNo == null) projectSerialNo = "";
	String buildingSerialNo = CurPage.getParameter("ObjectNo");
	if(buildingSerialNo == null) buildingSerialNo = "";
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";

	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("CLRMaginInfo",BusinessObject.createBusinessObject(),CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();

	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("ObjectNo", buildingSerialNo);
	dwTemp.setParameter("ObjectType","jbo.app.BUILDING_INFO");
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">

	function saveRecord(){
			as_save(0);
	}

	function initRow(){
		//楼盘项下保证金
		setItemValue(0,0,"ObjectType","jbo.app.BUILDING_INFO");
		setItemValue(0,0,"ObjectNo","<%=buildingSerialNo%>");
		var MarginSerialNo = getItemValue(0,0,"SERIALNO");
		var sReturn = ProjectManage.selectPaymentMoney(MarginSerialNo);
		setItemValue(0,0,"PaymentMoney",sReturn);
 		setItemValue(0,0,"AAIObjectType","jbo.guaranty.CLR_MARGIN_INFO");
		setItemValue(0,0,"AAIObjectNo",MarginSerialNo);
	}
	//校验账户信息
	function checkAccount(ai,at,an,ana,ac,an1,acid,amfcid)
	{
		var accountIndicator = getItemValue(0, getRow(), ai);
		var accountType = getItemValue(0, getRow(), at);
		var accountNo = getItemValue(0, getRow(), an);
		var accountName = getItemValue(0, getRow(), ana);
		var accountCurrency = getItemValue(0, getRow(), ac);
		
		if(typeof(accountNo) == "undefined" || accountNo.length == 0) return;
		
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","CheckClientCHNName",accountIndicator+","+accountNo+","+accountType+","+accountName+","+accountCurrency);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			setItemValue(0, getRow(0), ana, "");
			setItemValue(0, getRow(0), an1, "");
			return false;
		}else{
			setItemValue(0, getRow(0), an1, returnValue.split("@")[1]);
			setItemValue(0, getRow(0), ana, returnValue.split("@")[2]);
			setItemValue(0, getRow(0), acid, returnValue.split("@")[3]);
			setItemValue(0, getRow(0), amfcid, returnValue.split("@")[4]);
		}
		return true;
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
