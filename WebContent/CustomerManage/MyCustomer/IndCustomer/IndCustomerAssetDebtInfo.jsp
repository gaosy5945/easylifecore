<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%-- ҳ��˵��: �ͻ���Ϣ����->�ͻ�������Ϣ->�ʲ���ծ��Ϣҳ��--%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

    String ClientNo = "";
 	ASResultSet rs1 = Sqlca.getASResultSet(new SqlObject("select MFCustomerID from CUSTOMER_INFO where CustomerID=:CustomerID ").setParameter("CustomerID",customerID));
 	if(rs1.next()){
 		ClientNo=rs1.getString("MFCustomerID");
			if(ClientNo == null) {
				ClientNo = "";
			}
	}
	rs1.getStatement().close();
    
	String sTempletNo = "IndCustomerAssetDebtInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	if(!"".equals(ClientNo)){
		dwTemp.replaceColumn("FINANCEASSETINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"60\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/FinanceAssetInfo.jsp?customerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	}
	dwTemp.replaceColumn("INDCUSTOMERASSETLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerAssetList.jsp?customerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("INDCUSTOMERDEBTOUTLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerDebtOutList.jsp?customerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("INDCUSTOMERDEBTINNERLIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerDebtInnerList.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"false","All","Button","����","����","goBack(0)","","","",""}, 
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function initRow(){
		var ClientNo = "<%=ClientNo%>";
		if(ClientNo.length == 0){
			AsCredit.hideOWGroupItem("0005");
		}
	}
	initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
