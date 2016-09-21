 <%@page import="com.amarsoft.app.als.guaranty.model.CollateralAction"%>
 <%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String assetSerialNo =  CurPage.getParameter("AssetSerialNo");
	if(assetSerialNo == null) assetSerialNo=""; 
	String objectType =  CurPage.getParameter("ObjectType");
	if(objectType == null) objectType=""; 
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo == null) objectNo=""; 
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo=""; 
	
	String sTempletNo = "AssetRightCertInfo1Temp";//--模板号--

	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", SerialNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();	

	dwTemp.Style = "2";//freeform

	String editSource = CollateralAction.getRightCertSet(assetSerialNo);
	doTemp.setColumnAttribute("CertType", "ColEditSource", editSource);
	
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","","Button","返回","返回列表","returnBack()","","","",""}
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>

<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0");
	}
	function returnBack()
	{
	  AsControl.OpenView("/BusinessManage/GuarantyManage/AssetRightCertListNew.jsp","AssetSerialNo="+"<%=assetSerialNo%>"+"&ObjectType="+"<%=objectType%>"+"&ObjectNo="+"<%=objectNo%>","_self","");
	} 
	
	function initRow(){
		var SerialNo = "<%=SerialNo%>";
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			setItemValue(0,getRow(),"AssetSerialNo","<%=assetSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputDate","<%=com.amarsoft.app.base.util.DateHelper.getToday()%>");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
