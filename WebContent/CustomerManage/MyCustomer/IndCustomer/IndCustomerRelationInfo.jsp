<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String customerTypeTemp = CurPage.getParameter("CustomerType");
	if(customerTypeTemp == null) customerTypeTemp = "";
	String contractSerialNo = CurComp.getParameter("ContractSerialNo");
	if(contractSerialNo == null) contractSerialNo = "";
	String ListTypeTemp = CurPage.getParameter("ListType");
	if(ListTypeTemp == null) ListTypeTemp = "";
	String listType = "";
	
	String customerType = customerTypeTemp.substring(0, 2);
	if(!"".equals(ListTypeTemp)){
		listType = ListTypeTemp.substring(0, 2);
	}
	String CustomerFlag = "1";
	if("01".equals(customerType)){
		CustomerFlag = "2";
	}
	
	String sTempletNo = "IndCustomerRelationInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow("");

	dwTemp.replaceColumn("RELATIONINDINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerRelativeIndList.jsp?CustomerID="+customerID+"&CustomerType="+customerType+"&CustomerFlag="+CustomerFlag+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("RELATIONENTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerRelativeEntList.jsp?CustomerID="+customerID+"&CustomerType=01"+"&CustomerFlag="+CustomerFlag+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("PARTNERPROJECTINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/PartnerCustomer/PartnerCustomerProjectInfo.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"false","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
 function initRow(){
	if("<%=customerType%>" == "01" && ("<%=listType%>" != "00" || "<%=listType%>" == "")){
		AsCredit.hideOWGroupItem("0020");
		AsCredit.hideOWGroupItem("0030");
	}else if("<%=customerType%>" == "03"){
		AsCredit.hideOWGroupItem("0030");
	}else{
		AsCredit.hideOWGroupItem("0020");
	}	
}
initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
