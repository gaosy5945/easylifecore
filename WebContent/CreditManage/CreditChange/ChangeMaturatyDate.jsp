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

	String defaultDueDay="",rptTermID="";
	BizObjectManager bm = JBOFactory.getBizObjectManager(relativeObjectType);
	BizObject bo= bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", relativeObjectNo).getSingleResult(false);
	if(bo!=null){
		defaultDueDay=bo.getAttribute("REPAYDATE").getString();	
		rptTermID=bo.getAttribute("RPTTERMID").getString();	
		
	}
	if(defaultDueDay == null) defaultDueDay = "";
	String sTempletNo = "ChangeMaturatyDate01";//--模板号--
	/* ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request); */
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", objectNo);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style = "2";//freeform

	dwTemp.genHTMLObjectWindow(transSerialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},		
	};

%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function initRow(){
		var oldDefaultDueDay = getItemValue(0,getRow(),"OLDDEFAULTDUEDAY");
		if(typeof(oldDefaultDueDay)=="undefined"||oldDefaultDueDay.length==0){
			setItemValue(0,0,"OLDDEFAULTDUEDAY","<%=defaultDueDay%>");
		}
	}
	function saveRecord(){
		var oldDefaultDueDay = getItemValue(0,0,"OLDDEFAULTDUEDAY");
		var DefaultDueDay = getItemValue(0,0,"DEFAULTDUEDAY");
		if("<%=rptTermID%>"=="RPT-03"){
			alert("一次还本付息不可发起此变更，请删除该变更!");
			return;
		}
		if(DefaultDueDay==oldDefaultDueDay){
			alert("输入的扣款日与原扣款日不能相同，请重新输入!");
			return;
		}
		as_save(0);
	}
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
