<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

	String sTempletNo = "IndCustomerAccumulationInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	doTemp.setDefaultValue("CUSTOMERID", customerID);
	dwTemp.genHTMLObjectWindow(customerID);
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		};
	//sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		OpenPage("<%=customerID%>", "_self");
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
