<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String customerID =  CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";

	String sTempletNo = "IncomeSum";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
	};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
