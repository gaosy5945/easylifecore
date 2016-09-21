<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%-- 页面说明: 客户信息详情->客户基本信息->收入信息总页面--%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

	String sTempletNo = "IndCustomerIncomeInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(customerID);
	dwTemp.replaceColumn("INDCUSTOMERINCOMELIST", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"680\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/MyCustomer/IndCustomer/IndCustomerIncomeList.jsp?CustomerID="+customerID+"&CompClientID=" + sCompClientID + "\"></iframe>", CurPage.getObjectWindowOutput());
		
	String sButtons[][] = {
		{"false","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"false","All","Button","返回","返回","goBack(0)","","","",""}, 
	};
%>

<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function goBack(){ 
		self.close();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
