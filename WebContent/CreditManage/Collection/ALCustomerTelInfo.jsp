<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String customerID = CurPage.getParameterNoCheck("CustomerID");

	String sTempletNo = "ALCustomerTelInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","save()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		setItemValue(0, getRow(0), "UPDATEUSERID", "<%=CurUser.getUserID()%>");
		setItemValue(0, getRow(0), "UPDATEORGID", "<%=CurUser.getOrgID()%>");
		setItemValue(0, getRow(0), "UPDATEDATE", "<%=DateHelper.getBusinessDate()%>");
		setItemValue(0, getRow(0), "CUSTOMERID", "<%=customerID%>");
		as_save(0);
	}
	function returnList(){
		self.close();
	}
	setItemValue(0, getRow(0), "CustomerID", "<%=customerID%>");
	setItemValue(0, getRow(0), "INPUTUSERID", "<%=CurUser.getUserID()%>");
	setItemValue(0, getRow(0), "INPUTORGID", "<%=CurUser.getOrgID()%>");
	setItemValue(0, getRow(0), "INPUTDATE", "<%=DateHelper.getBusinessDate()%>");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
