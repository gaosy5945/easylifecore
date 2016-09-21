<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	
	String sTempletNo = "EntCustomerBuildingInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.Style = "2";//freeform
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	doTemp.setDefaultValue("INPUTORGName", CurOrg.getOrgName());
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function initRow(){
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			setItemValue(0,0,"CUSTOMERID","<%=customerID%>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateHelper.getBusinessDate()%>");
		}
		setItemValue(0,0,"UPDATEDATE","<%=DateHelper.getBusinessDate()%>");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
