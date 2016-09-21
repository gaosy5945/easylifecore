<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.ALSBusinessProcess"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	String relativeObjectNo = CurPage.getParameter("RelativeObjectNo");
	String relativeObjectType = CurPage.getParameter("RelativeObjectType");	
	if(objectNo == null) objectNo = "";
	if(objectType == null) objectType = "";
	if(relativeObjectNo == null) relativeObjectNo = "";
	if(relativeObjectType == null) relativeObjectType = "";
	if(transSerialNo == null) transSerialNo = "";
	if(transCode == null) transCode = "";
	BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
	BusinessObject relativeObject = bom.loadBusinessObject(relativeObjectType, relativeObjectNo);
	double balance = relativeObject.getDouble("balance");
	double normalbalance = relativeObject.getDouble("normalbalance");

	String sTempletNo = "PrePaymentInfo01";//--模板号--
	/* ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request); */
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", objectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},	
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord()
	{
		beforeUpdate();	
		
		if(!iV_all(0)) return;
		
		var returnvalue = getInteAmt();
		if("true"!=returnvalue)return;
		
		as_save("myiframe0");
	}
	function beforeUpdate(){
		setItemValue(0,0,"OBJECTTYPE","jbo.app.BUSINESS_DUEBILL");	
		setItemValue(0,0,"OBJECTNO","<%=relativeObjectNo%>");	
	}
	function getInteAmt(){
		var repymtPrncpl = getItemValue(0, getRow(0), "PREPAYPRINCIPALAMT");
		var duebillNo= "<%=relativeObjectNo%>";
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.CheckInteAmt","getInteAmt","DuebillNo="+duebillNo+",RepymtPrncpl="+repymtPrncpl);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue.split("@")[0] == "false"){
			alert(returnValue.split("@")[1]);
			return returnValue.split("@")[0];
		}else{			
			var  actualPayment = repymtPrncpl *1.0 +returnValue.split("@")[1] *1.0;
			setItemValue(0, getRow(0), "PREPAYINTEAMT", returnValue.split("@")[1]);
			setItemValue(0, getRow(0), "PREPAYAMOUNT", actualPayment);
			return returnValue.split("@")[0];
		}
	}
		
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
