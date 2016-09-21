<%@page import="org.apache.poi.ss.usermodel.DateUtil"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>

<%
	String PG_TITLE = "批量估值签署意见"; 
	String serialNo = CurPage.getParameter("SerialNo");if(serialNo == null)serialNo = "";
	String rightType = CurPage.getParameter("RightType");if(rightType == null)rightType = "ALL";
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("MutilApproveInfo",BusinessObject.createBusinessObject(),CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为只读

	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			{"true","All","Button","保存","保存","saveRecord()","","","",""},
	};
%>

<%@include file="/Frame/resources/include/ui/include_info.jspf" %>

<script type="text/javascript">
	function closeSelf(){
		var phaseactionType = getItemValue(0,0,"PHASEACTIONTYPE");
		top.returnValue = phaseactionType;
		self.close();
	} 

	var rightType = "<%=rightType%>";
	function saveRecord(){
		as_save(0,"");
	}
	
	
	function init(){
			var userId = getItemValue(0,getRow(),"ApproveUserID");
			var orgId = getItemValue(0,getRow(),"ApproveOrgID");
			var evaDate = getItemValue(0,getRow(),"UpdateDate");
			
			if(userId == '') {
				setItemValue(0,0,"ApproveUserID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"ApproveUserName","<%=CurUser.getUserName()%>");
			}
			if(orgId == '') {
				setItemValue(0,0,"ApproveOrgID","<%=CurUser.getOrgID()%>");
				setItemValue(0,0,"ApproveOrgName","<%=CurUser.getOrgName()%>");
			}
			if(evaDate == '') {
				setItemValue(0,0,"UpdateDate","<%=DateHelper.getToday()%>");
			}
	}
	
	init();
</script>


<%@ include file="/Frame/resources/include/include_end.jspf"%>
