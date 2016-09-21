<%@page import="org.apache.poi.ss.usermodel.DateUtil"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>

<%
	String PG_TITLE = "ѺƷ����"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("GuarantyEvaluateMutilInfo",BusinessObject.createBusinessObject(),CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	doTemp.setDefaultValue("EvaluateMethod", "1");
	doTemp.setDefaultValue("EvaluateScenario", "3");
	
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����Ϊfreeform���
	dwTemp.ReadOnly = "0"; //����Ϊֻ��

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","����","����","saveRecord()","","","",""},
	};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function closeSelf(){
		var cmisbtchApplyno = getItemValue(0,0,"CMISBTCHAPPLYNO");
		top.returnValue = cmisbtchApplyno;
		self.close();
	} 

	function saveRecord(){
		as_save(0,"");
	}
	
	
	function init(){
		if(getRowCount(0)==0){
			var userId = getItemValue(0,getRow(),"EvaluateUserID");
			var orgId = getItemValue(0,getRow(),"EvaluateOrgID");
			var evaDate = getItemValue(0,getRow(),"EvaDate");
			
			if(userId == '') {
				setItemValue(0,0,"EvaluateUserID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"EvaluateUserName","<%=CurUser.getUserName()%>");
			}
			if(orgId == '') {
				setItemValue(0,0,"EvaluateOrgID","<%=CurUser.getOrgID()%>");
				setItemValue(0,0,"EvaluateOrgName","<%=CurUser.getOrgName()%>");
			}
			if(evaDate == '') {
				setItemValue(0,0,"EvaDate","<%=DateHelper.getToday()%>");
			}
		}
	}
	
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
