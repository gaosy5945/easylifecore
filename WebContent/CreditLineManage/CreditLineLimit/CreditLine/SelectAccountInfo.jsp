<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "SelectAccountInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","确定","确定","save()","","","",""},
		{"true","All","Button","返回","返回列表","self.close()","","","",""}
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function save(){
		var BusinessType = getItemValue(0, getRow(0), "BusinessType");
		var ObjectNo = getItemValue(0, getRow(0), "ObjectNo");
		var CustomerID = getItemValue(0, getRow(0), "CustomerID");
		var CustomerName = getItemValue(0, getRow(0), "CustomerName");
		var operateType = getItemValue(0, getRow(0), "OperateType");
		var orgID = "<%=CurUser.getOrgID()%>";
		var userID = "<%=CurUser.getUserID()%>";
		var serialNo = "";
		var functionID = "";
		var returnValue = AsControl.PopView("/CreditLineManage/CreditLineLimit/CreditLine/SelectCLAcountList.jsp", "CustomerID="+CustomerID+"&CustomerName="+CustomerName+"&ObjectNo="+ObjectNo+"&BusinessType="+BusinessType,"dialogWidth:800px;dialogHeight:680px;")
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
		{
			return;
		}
		var returns = returnValue.split("@");
		var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.LimitInsertTransaction", "addUser", "SerialNo="+returns[0]+",LineID="+returns[1]+",TransactionCode="+operateType+",UserID="+userID+",OrgID="+orgID);
		if(typeof(returnValue1) == "undefined" || returnValue1.length == 0 || returnValue1.indexOf("@") == -1){
			return;
		}else{
			serialNo = returnValue1.split("@")[1];
		}
		var returnValue2 = AsControl.RunASMethod("AfterBusiness","LimitTransactionInfo",serialNo+","+userID+","+orgID);
		if(typeof(returnValue2) == "undefined" || returnValue2.length == 0 || returnValue2.indexOf("@") == -1){
			return;
		}else{
			if(returnValue2.split("@")[0] == "true"){
				var serialNo = returnValue2.split("@")[1];
				functionID = returnValue2.split("@")[2];
				var flowSerialNo = returnValue2.split("@")[3];
				var taskSerialNo = returnValue2.split("@")[4];
				var phaseNo = returnValue2.split("@")[5];
				var msg = returnValue2.split("@")[6];
			}
		}
		self.close();
		self.returnValue = functionID;
	}
	
	function selectCustomer()
	{
		var returnValue = AsDialog.SelectGridValue('SelectApplyCustomer',"<%=CurUser.getUserID()%>, ",'CustomerID@CustomerName@CertType@CertID@CustomerType','');
		if(typeof(returnValue)=="undefined"||returnValue=="_CANCEL_"
			||returnValue==""||returnValue=="null")
		{
			return;
		}else{
			setItemValue(0, getRow(0), "CustomerID", returnValue.split("@")[0]);
			setItemValue(0, getRow(0), "CustomerName", returnValue.split("@")[1]);
			setItemValue(0, getRow(0), "CertID", returnValue.split("@")[3]);
		}
	}
	
	function selectBusinessContract()
	{
		var customerid = getItemValue(0,getRow(0),"CUSTOMERID");
		if(typeof(customerid)=="undefined"||customerid.length==0)
		{
			alert("请先选择客户！");
			return;
		}
		
		var returnValue = AsDialog.SelectGridValue('SelectContractByCustomer',"<%=CurUser.getUserID()%>,"+customerid,'SerialNo@BusinessType','');
		if(typeof(returnValue)=="undefined"||returnValue=="_CANCEL_"
			||returnValue==""||returnValue=="null")
		{
			return;
		}else{
			setItemValue(0, getRow(0), "ObjectNo", returnValue.split("@")[0]);
			setItemValue(0, getRow(0), "BusinessType", returnValue.split("@")[1]);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
