<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID =  CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

	String sTempletNo = "IncomeSum";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","保存","保存所有修改","as_save(0)","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
