<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String objectType = CurPage.getParameter("ObjectType");
	if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo == null) objectNo = "";

	//汽车贷款附属信息
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("BusinessVehicle",BusinessObject.createBusinessObject(),CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0";//只读模式
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""}
	};
	
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save(0);
	}
	
	function refresh(){
		AsControl.OpenComp("/CreditManage/CreditApply/BusinessVehicle.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>", "_self", "");
	}
	
	function calcFirstPayRatio(){
		var contractAmount = getItemValue(0,getRow(),"ContractAmount");
		var firstPayAmount = getItemValue(0,getRow(),"FirstPayAmount");
		if(contractAmount != null && contractAmount.length != 0 && firstPayAmount != null && firstPayAmount.length != 0){
			if(contractAmount == 0){
				setItemValue(0,getRow(),"FirstPayPercent",0);
				return;
			}
			var ratio = 100*firstPayAmount/contractAmount;
			setItemValue(0,getRow(),"FirstPayPercent",ratio);
		}
		else{
			setItemValue(0,getRow(),"FirstPayPercent",0);
		}
	}
	
	function init(){
		setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
	}
	
	init();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
