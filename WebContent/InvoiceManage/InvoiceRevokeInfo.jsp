<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-11
        Content: 示例详情页面
        History Log: 
    */
	String serialNo = CurPage.getParameter("serialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "InvoiceRevokeInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","确定","确定","revoke()","","","",""},
			{"true","All","Button","取消","取消","top.close();","","","",""}, 
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function revoke(){
		if(!iV_all("0")) return ;
		var reason = getItemValue(0,getRow(0),'reason');
		var record = "<%=serialNo%>"+"&"+reason;
		var result = RunJavaMethod("com.amarsoft.app.als.afterloan.invoice.InvoiceCreat","InvoiceRevoke","record="+record);
		if(result=="true")
			alert("红冲原因已记录在票据备注中！");
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>