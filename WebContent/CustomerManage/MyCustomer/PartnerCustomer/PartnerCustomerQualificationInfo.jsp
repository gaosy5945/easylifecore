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

	String sTempletNo = "PCQualificationInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	//����listType�Ĳ�ͬ�����ò�ͬ���ֶ���ʾ
	if("00".equals(listType.substring(0, 2))&&!"0001".equals(listType)&&!"0004".equals(listType)){
		doTemp.setColumnAttribute("CERTNAME", "colheader", "��Ӫ����");
		doTemp.setColumnAttribute("VALIDDATE", "colheader", "��Ӫ������Ч����");
	}else if("0004".equals(listType)){//����������ֶδ���
		doTemp.setColumnAttribute("CERTNAME", "colheader", "��ӪƷ��");
		doTemp.setVisible("CERTTYPE", true);
		doTemp.setVisible("REMARK", true);
		doTemp.setColumnAttribute("VALIDDATE", "colheader", "��Ӫ������Ч����");
	}
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform

	dwTemp.genHTMLObjectWindow(customerID);
	dwTemp.replaceColumn("ISBLACKLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"500\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/PartnerCustomer/PartnerCustomerSpecialList.jsp?CertType="+CertType+"&CertID="+CertID+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
			{"true","All","Button","����","���������޸�","saveRecord()","","","","btn_icon_save",""},
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
