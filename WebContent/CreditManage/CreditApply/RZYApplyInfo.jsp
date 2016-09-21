<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>

<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%
	String PG_TITLE = "�����׶����Ϣ"; 
	String templateNo = "ApplyCLInfoRZY";
	String objectType = CurPage.getParameter("ObjectType");if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");if(objectNo == null) objectNo = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templateNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.ReadOnly = "0"; //����Ϊֻ��

	//dwTemp.genHTMLObjectWindow(objectType+","+objectNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","����","����","saveRecord()","","","",""}
	};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function saveRecord(){
		if (getRowCount(0)==0){
			setItemValue(0,getRow(),"InputDate","<%=DateHelper.getToday()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
		}
		
		as_save();
	}
	
	function init(){

	}
	
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
