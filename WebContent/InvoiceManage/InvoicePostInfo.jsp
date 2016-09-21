<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-11
        Content: 示例详情页面
        History Log: 
    */
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "InvoicePostInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
		{"true","All","Button","确定","确定","post()","","","",""},
		{"true","All","Button","取消","取消","top.close();","","","",""}, 
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function post(){
		if(!iV_all("0")) return ;
		<%-- var postCompanyName = getItemValue(0,getRow(0),'PostCompanyName');
		var postNumber = getItemValue(0,getRow(0),'PostNumber');
		var postManId = getItemValue(0,getRow(0),'PostManId');
		var postManName = getItemValue(0,getRow(0),'PostManName');
		var postManPhone = getItemValue(0,getRow(0),'PostManPhone');
		var record = "<%=serialNo%>"+"&"+postCompanyName+"&"+postNumber+"&"+postManId+"&"+postManName+"&"+postManPhone;
		var result = RunJavaMethod("com.amarsoft.app.als.afterloan.invoice.InvoicePost","InvoicePost","record="+record);
		if(result=="true")
			alert("快递信息已记录在票据备注中！"); --%>
		setItemValue(0,getRow(),"status","02");
		as_save(0);
		alert("快递信息已记录!");
		top.close();
	}



</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>