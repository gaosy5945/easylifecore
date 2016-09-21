<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
String applyType = CurPage.getParameter("ApplyType");
	String sTempletNo = "ProjectNewInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回","top.close()","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<HEAD>
<title>合作项目建立</title>
</HEAD>
<script type="text/javascript">
function selectCustomer(){
	AsDialog.SetGridValue("SelectPartnerCustomer", "<%=CurUser.getUserID()%>", "CustomerID=CustomerID@CustomerName=CustomerName@CertType=CertType@CertID=CertID@ListType=ListType", "");
}
function saveRecord(){
	//as_save("myiframe0","");	
	if(!iV_all("myiframe0"))return;
	var para = "";
	para=para+"userID=<%=CurUser.getUserID()%>";
	para=para+",orgID=<%=CurOrg.getOrgID()%>";
	para=para+",serialNo="+getItemValue(0,getRow(),"SerialNo");
	para=para+",customerID="+getItemValue(0,getRow(),"CustomerID");
	para=para+",projectType="+getItemValue(0,getRow(),"ProjectType");
	para=para+",applyType=<%=CurPage.getParameter("ApplyType")%>";
	para=para+",listType="+getItemValue(0,getRow(),"ProjectType");
	para=para+",projectName="+getItemValue(0,getRow(),"ProjectName");
	
	var customer = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.InitProjectApply","initProjectApply",para);
	if(typeof(customer) == "undefined" || customer.length == 0 || customer.indexOf("@") == -1)
	{
		return;
	}
	else
	{
		var flag = customer.split("@")[0];
		var serialNo = customer.split("@")[1];
		var customerID = customer.split("@")[2];
		var functionID = customer.split("@")[3];
		var flowSerialNo = customer.split("@")[4];
		var taskSerialNo = customer.split("@")[5];
		var phaseNo = customer.split("@")[6];
		var msg = customer.split("@")[7];
		setItemValue(0,getRow(),"CustomerID",customerID);
		setItemValue(0,getRow(),"SerialNo",serialNo);
		//AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.UpdateAgreementNo", "udpateAgreementNo", "SerialNo="+customer.split("@")[1]);
		alert(msg);
		if(flag == "true")
		{		
			top.returnValue = flag+"@"+taskSerialNo+"@"+flowSerialNo+"@"+phaseNo+"@"+functionID;
			top.close();
		}
	}
}
function edit(){
	var SerialNo = getItemValue(0,getRow(0),"SerialNo");
	var ProjectType = getItemValue(0,getRow(0),"ProjectType");
    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+SerialNo+"&ProjectType="+ProjectType);
    top.close();
}


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
