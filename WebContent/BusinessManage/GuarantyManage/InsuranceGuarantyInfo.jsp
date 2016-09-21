<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	String PG_TITLE = "押品保险详情"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null) serialNo = "";
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null) objectNo = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", serialNo);
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CollateralInsuranceInfo", inputParameter,CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(doTemp, CurPage, request);

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""},
		};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function saveRecord(){
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),"InputDate","<%=DateHelper.getBusinessDate()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"ObjectType","<%=objectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=objectNo%>");
		}
		setItemValue(0,getRow(),"UpdateDate","<%=DateHelper.getBusinessDate()%>");
		
		as_save("0",'');
	}
	
	function init(){
		if (getRowCount(0)!=0){
			setItemDisabled(0,getRow(),"InsuranceNo",true);
		}
	}
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
