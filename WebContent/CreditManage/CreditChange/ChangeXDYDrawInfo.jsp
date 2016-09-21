<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.ALSBusinessProcess"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String documentObjectNo = CurPage.getParameter("ObjectNo");
	String documentObjectType = CurPage.getParameter("ObjectType");
	String transSerialNo = CurPage.getParameter("TransSerialNo");
	String transCode = CurPage.getParameter("TransCode");
	String relativeObjectNo = CurPage.getParameter("RelativeObjectNo");
	String relativeObjectType = CurPage.getParameter("RelativeObjectType");	
	if(documentObjectNo == null) documentObjectNo = "";
	if(documentObjectType == null) documentObjectType = "";
	if(relativeObjectNo == null) relativeObjectNo = "";
	if(relativeObjectType == null) relativeObjectType = "";
	if(transSerialNo == null) transSerialNo = "";
	if(transCode == null) transCode = "";

	BizObjectManager bm = JBOFactory.getBizObjectManager(documentObjectType);
	BizObject bo= bm.createQuery("serialno=:serialno").setParameter("serialno",documentObjectNo).getSingleResult(false);
	String oldIsOpenDraw = "";
	if(bo!=null){
		oldIsOpenDraw = bo.getAttribute("OLDISOPENDRAW").getString();	
	}
	String sTempletNo = "ChangeXDYDrawInfo";//--模板号--

	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", documentObjectNo); //变更明细编号
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
		var oldIsOpenDraw = getItemValue(0,getRow(),"OLDISOPENDRAW");
		<%-- if(typeof(oldIsOpenDraw)=="undefined"||oldIsOpenDraw.length==0){
			setItemValue(0,0,"OLDISOPENDRAW","<%=oldIsOpenDraw%>");
			oldIsOpenDraw = <%=oldIsOpenDraw%>;		
		} --%>		
		if(oldIsOpenDraw == "1"){
			setItemValue(0,0,"ISOPENDRAW","0");
		}
		else{
			setItemValue(0,0,"ISOPENDRAW","1");
		}
	}
	function saveRecord(){
		as_save(0);
	}
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
