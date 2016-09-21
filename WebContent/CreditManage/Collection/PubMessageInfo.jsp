<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String customerID = CurPage.getParameterNoCheck("CustomerID");

	String sTempletNo = "PubMessageInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","提交","提交","sub()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function selectPhoneNo(){
		var CustomerID = "<%=customerID%>";
		var returnValue = AsDialog.SelectGridValue('ALCustomerTelList',"<%=customerID%>,<%=CurUser.getUserID()%>",'RELATIONSHIP@TELEPHONE@OWNER','',"","dialogWidth:400px;dialogHeight:400px;");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
		{
			return;
		}
		setItemValue(0, getRow(0), "RELATIONSHIP", returnValue.split("@")[0]);
		setItemValue(0, getRow(0), "TELEPHONE", returnValue.split("@")[1]);
		setItemValue(0, getRow(0), "OWNER", returnValue.split("@")[2]);
	}
	
	function selectPhoneModel(){
		var CustomerID = "<%=customerID%>";
		var returnValue = AsDialog.SelectGridValue('ALCustomerTelModelList',"<%=customerID%>,<%=CurUser.getUserID()%>",'RELATIONSHIP@TELEPHONE@OWNER','',"","dialogWidth:400px;dialogHeight:400px;");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
		{
			return;
		}
		setItemValue(0, getRow(0), "RELATIONSHIP", returnValue.split("@")[0]);
		setItemValue(0, getRow(0), "TELEPHONE", returnValue.split("@")[1]);
		setItemValue(0, getRow(0), "OWNER", returnValue.split("@")[2]);
	}
	
	function sub(){
		var telephone = getItemValue(0, getRow(), "TELEPHONE");
		var context = getItemValue(0, getRow(), "CONTEXT");
		var serialNo = "<%=serialNo%>"
		if(context == ""){
			alert("请选择短信模板");
			return;
		}
		var returnValue = AsControl.RunASMethod("CollTask", "SendMessage", telephone+","+context+","+serialNo);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
		{
			return;
		}
		if(returnValue.split("@")[0] == "true"){
			alert(returnValue.split("@")[1])
			self.close();
		}
	}
	function returnList(){
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
