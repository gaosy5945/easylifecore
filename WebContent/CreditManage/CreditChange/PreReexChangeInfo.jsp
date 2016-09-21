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

	String sTempletNo = "PreReexChangeInfo";//--模板号--
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
		{"false","All","Button","保存","保存所有修改","saveRecord()","","","",""},	
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord()
	{
		beforeUpdate();	
		
		if(!iV_all(0)) return;
		
		//校验提前还款本金不得大于贷款余额， add by bhxiao 20150420
		<%-- var bdBalance = "<%=balance%>";
		var repymtPrncpl = getItemValue(0, getRow(0), "PAYAMT");
		if( parseFloat(repymtPrncpl) > parseFloat(bdBalance)){
			alert("还款金额不能大于贷款余额！");
			return;
		} --%>
		
		as_save("myiframe0");
	}
	
	function beforeUpdate(){
		setItemValue(0,0,"OBJECTTYPE","jbo.app.BUSINESS_DUEBILL");	
		setItemValue(0,0,"OBJECTNO","<%=relativeObjectNo%>");	
	}
	
	function init(){
		var bdBalance = "<%=balance%>";
		var repymtPrncpl = getItemValue(0, getRow(0), "PAYAMT");
		if(typeof(repymtPrncpl)=="undefined"||repymtPrncpl.length==0
				||repymtPrncpl==""||repymtPrncpl<=0){
			setItemValue(0,0,"PAYAMT",bdBalance);	
		}
	}
	
	$(document).ready(function(){
		init();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
