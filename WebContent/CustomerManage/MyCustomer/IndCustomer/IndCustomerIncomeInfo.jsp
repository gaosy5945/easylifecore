<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%-- ҳ��˵��: �ͻ���Ϣ����->�ͻ�������Ϣ->������Ϣ��ҳ��--%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

	String sTempletNo = "IndCustomerIncomeInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(customerID);
	dwTemp.replaceColumn("INDCUSTOMERINCOMELIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"680\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerIncomeList.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
		
	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"false","All","Button","����","����","goBack(0)","","","",""}, 
	};
%>

<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function goBack(){ 
		self.close();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
