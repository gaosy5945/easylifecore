<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	String customerID = CurPage.getParameter("CustomerID");
	if(serialNo == null) serialNo = "";
	if(customerID == null) customerID = "";

	String sTempletNo = "ShareApplyInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow(customerID);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setItemValue(0, getRow(), "CustomerID", "<%=customerID%>");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
