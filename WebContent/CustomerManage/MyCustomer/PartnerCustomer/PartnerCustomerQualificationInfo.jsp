<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurComp.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	String listType = CurComp.getParameter("ListType");
	if(listType == null) listType = "";
	String CertType = CurComp.getParameter("CertType");
	if(CertType == null) CertType = "";
	String CertID = CurComp.getParameter("CertID");
	if(CertID == null) CertID = "";

	String sTempletNo = "PCQualificationInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	//根据listType的不同，设置不同的字段显示
	if("00".equals(listType.substring(0, 2))&&!"0001".equals(listType)&&!"0004".equals(listType)){
		doTemp.setColumnAttribute("CERTNAME", "colheader", "经营资质");
		doTemp.setColumnAttribute("VALIDDATE", "colheader", "经营资质有效期限");
	}else if("0004".equals(listType)){//经销商相关字段处理
		doTemp.setColumnAttribute("CERTNAME", "colheader", "经营品牌");
		doTemp.setVisible("CERTTYPE", true);
		doTemp.setVisible("REMARK", true);
		doTemp.setColumnAttribute("VALIDDATE", "colheader", "经营资质有效期限");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform

	dwTemp.genHTMLObjectWindow(customerID);
	dwTemp.replaceColumn("ISBLACKLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"500\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/PartnerCustomer/PartnerCustomerSpecialList.jsp?CertType="+CertType+"&CertID="+CertID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()","","","","btn_icon_save",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	function saveRecord(){
		as_save("myiframe0");
}
	function initRow(){
		setItemValue(0,0,"CUSTOMERID","<%=customerID%>");
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
