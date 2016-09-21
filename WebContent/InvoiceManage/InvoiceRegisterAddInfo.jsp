<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.als.prd.analysis.dwcontroller.impl.DefaultObjectWindowController"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>

<%
	String listTempletNo = CurPage.getParameter("ListTempletNo");
	String direction = CurPage.getParameter("Direction");
	String invoiceobject = CurPage.getParameter("InvoiceObject");
	if(direction == null) direction = "";
	if(listTempletNo == null) listTempletNo = "";
	if(invoiceobject == null) invoiceobject = "";

	String sTempletNo = CurPage.getParameter("TempletNo");
	//ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	//dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	//dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("SerialNo", CurPage.getParameter("SerialNo"));
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(sTempletNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	if("03".equals(invoiceobject)) doTemp.setVisible("taxnumber", false);
	doTemp.setVisible("InvoiceDetail", false);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function SelectCustomer(){
		var returnValue = null;
		if("<%=invoiceobject%>"=="01"){
			returnValue = AsDialog.SetGridValue('SelectInvoiceCustomerList',"0023",'CUSTOMERID@CUSTOMERNAME@TAXNUMBER@ADDRESS1@TELEPHONE@ACCOUNTORGID@ACCOUNTNO','');	
		}else if("<%=invoiceobject%>"=="02"){
			returnValue = AsDialog.SetGridValue('SelectInvoiceCustomerList',"0020",'CUSTOMERID@CUSTOMERNAME@TAXNUMBER@ADDRESS1@TELEPHONE@ACCOUNTORGID@ACCOUNTNO','');
		}else if("<%=invoiceobject%>"=="03"){
			returnValue = AsDialog.SetGridValue('SelectInvoiceIndCustomerList',"",'CUSTOMERID@CUSTOMERNAME@TAXNUMBER@ADDRESS1@TELEPHONE@ACCOUNTORGID@ACCOUNTNO','');
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
		setItemValue(0,0,"direction","<%=direction%>");
		setItemValue(0,0,"invoiceobject","<%=invoiceobject%>");
		setItemValue(0,0,"invoiceserialno",getItemValue(0,getRow(),"serialno"));
		as_save("openInfo()");
	}
	
	function openInfo(){
		var sUrl = "/InvoiceManage/InvoiceRegisterInfo.jsp";
		var sPara = getItemValue(0,getRow(),"serialno");
		var purpose = getItemValue(0,getRow(),"purpose");
		var templetNo = "R_InvoiceRegisterInfo";
		if("<%=direction%>"=="P"){
			if("<%=invoiceobject%>" == "03"){
				 templetNo = "P_InvoiceRegisterIndInfo";
			 }else{
				 templetNo = "P_InvoiceRegisterInfo";
			 }
		}
		AsControl.OpenView(sUrl,"SerialNo=" +sPara+"&TempletNo="+templetNo+"&Direction="+"<%=direction%>"+"&ListTempletNo="+"<%=listTempletNo%>"+'&InvoiceObject='+"<%=invoiceobject%>"+"&Purpose="+purpose ,"_self","");
	}
	
	function returnList(){
		 AsControl.OpenView("/InvoiceManage/InvoiceRegisterList.jsp", "TempletNo="+"<%=listTempletNo%>"+"&Direction="+"<%=direction%>"+'&InvoiceObject='+"<%=invoiceobject%>","_self","");
	}
	function initRow(){
		setItemValue(0,getRow(),"status","00");
		setItemValue(0,getRow(),"inputorgid","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"inputorgname","<%=CurUser.getOrgName()%>");
		setItemValue(0,getRow(),"inputuserid","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"inputusername","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"inputtime","<%=DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"occurdate","<%=DateHelper.getBusinessDate()%>");
	}
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>