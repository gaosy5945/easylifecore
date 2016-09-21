<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@page import="com.amarsoft.app.als.prd.analysis.dwcontroller.impl.DefaultObjectWindowController"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%
	
	String sTempletNo = CurPage.getParameter("TempletNo");//--模板号--
	String listTempletNo = CurPage.getParameter("ListTempletNo");
	String invoiceobject = CurPage.getParameter("InvoiceObject");
	if(invoiceobject == null) invoiceobject = "";
	if(listTempletNo == null) listTempletNo = "";
	String direction = CurPage.getParameter("Direction");
	if(direction == null) direction = "";
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	//ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	
	//通过显示模版产生ASDataObject对象doTemp
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", serialNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	if("03".equals(invoiceobject)) doTemp.setVisible("taxnumber", false);
	/* if("03".equals(invoiceobject)) doTemp.setVisible("InvoiceRelative", false); */
	
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");
	
	
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	//dwTemp.replaceColumn("InvoiceDetail", "<iframe id='iframe' type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/InvoiceManage/InvoiceDetailList.jsp?InvoiceSerialNo="+serialNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""},
		{"false","All","Button","确认","确认","changeStatus()","","","",""},
		{"false","All","Button","项目金额查看","项目金额查看","checkPrjAmt()","","","",""},
		{"false","All","Button","查看业务合同","查看业务合同","checkBusinessContract()","","","",""},
	};
	if(!serialNo.isEmpty()) sButtons[2][0] = "true";
	if("03".equals(invoiceobject)) sButtons[4][0] = "true";
	/* if(!serialNo.isEmpty()&&invoiceobject.equals("01")) sButtons[3][0] = "true"; */
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function reloadPage(){
		var obj = document.getElementById("sys_sub_page_frame_InvoiceDetail");
		window.frames["sys_sub_page_frame_InvoiceDetail"].reloadSelf();
		window.frames["sys_sub_page_frame_InvoiceDetail"].saveRecord();
	}
	function SelectCustomer(){
		var returnValue = null;
		if("<%=invoiceobject%>"=="01"){
			returnValue = AsDialog.SetGridValue('SelectInvoiceCustomerList',"0023",'CUSTOMERID@CUSTOMERNAME@TAXNUMBER@ADDRESS1@TELEPHONE@ACCOUNTORGID@ACCOUNTNO','');	
		}else if("<%=invoiceobject%>"=="02"){
			returnValue = AsDialog.SetGridValue('SelectInvoiceCustomerList',"0020",'CUSTOMERID@CUSTOMERNAME@TAXNUMBER@ADDRESS1@TELEPHONE@ACCOUNTORGID@ACCOUNTNO','');
		}else if("<%=invoiceobject%>"=="03"){
			returnValue = AsDialog.SetGridValue('SelectInvoiceIndCustomerList',"",'CUSTOMERID@CUSTOMERNAME@TAXNUMBER@ADDRESS1@TELEPHONE@ACCOUNTORGID@ACCOUNTNO','');
		}
		if(typeof(returnValue) == "undefined" || returnValue == "_CLEAR_"){
			return;
		}
		if(returnValue == null){
			setItemValue(0,0,"objectno","");
			setItemValue(0,0,"companyname","");
			setItemValue(0,0,"taxnumber","");
			setItemValue(0,0,"address","");
			setItemValue(0,0,"telephone","");
			setItemValue(0,0,"bank","");
			setItemValue(0,0,"accountno","");
		}
		else{
			setItemValue(0,0,"objectno",returnValue.split("@")[0]);
			setItemValue(0,0,"companyname",returnValue.split("@")[1]);
			setItemValue(0,0,"taxnumber",returnValue.split("@")[2]);
			setItemValue(0,0,"address",returnValue.split("@")[3]);
			setItemValue(0,0,"telephone",returnValue.split("@")[4]);
			setItemValue(0,0,"bank",returnValue.split("@")[5]);
			setItemValue(0,0,"accountno",returnValue.split("@")[6]);
		}
	}
	function saveRecord(){
		as_save(0);
	}
	function returnList(){
		 AsControl.OpenView("/InvoiceManage/InvoiceRegisterList.jsp", "TempletNo="+"<%=listTempletNo%>"+"&Direction="+"<%=direction%>"+'&InvoiceObject='+"<%=invoiceobject%>","_self","");
	}
	function calculateAmount(invoiceAmount,taxAmount){
		if(invoiceAmount == 'NaN' || invoiceAmount == '') invoiceAmount = "0";
		if(taxAmount == 'NaN' || taxAmount == '') taxAmount = "0";
		setItemValue(0,getRow(),"invoiceamount",invoiceAmount);
		setItemValue(0,getRow(),"taxamount",taxAmount);
		saveRecord();
	}
	function initRow(){
		var SerialNo = "<%=serialNo%>";
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			setItemValue(0,0,"inputorgid","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"inputorgname","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputusername","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"inputtime","<%=DateHelper.getBusinessDate()%>");
		}
	}
	function changeStatus(){
		var status = getItemValue(0,getRow(0),'status');
		
		if("<%=direction%>"=="R"){
			setItemValue(0,0,"status","03");
		}else if("<%=direction%>"=="P"){
			if(confirm("是否需要邮寄？")){
				setItemValue(0,0,"status","01");
			}else{
				setItemValue(0,0,"status","03");
			}
		}
		saveRecord();
	}
	function checkPrjAmt(){
		var customerid = getItemValue(0,getRow(0),'objectno');
		OpenPage("/InvoiceManage/InvoiceProjectAmount.jsp?CustomerID="+customerid,"","width=50px,height=40px");
	}
	function checkBusinessContract(){
		var serialNo = getItemValue(0,getRow(),"serialno");
		var sReturn = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.invoice.InvoiceRelative","GetRelativeSerialNo","SerialNo="+serialNo);
		var ALSerialNo = sReturn.split("@")[0];
		var ApplySerialNo = sReturn.split("@")[1];
		var ContractSerialNo = sReturn.split("@")[2];
		AsCredit.openFunction("LoanTab","SerialNo="+ALSerialNo+"&ContractSerialNo="+ContractSerialNo+"&ApplySerialNo="+ApplySerialNo,"");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>