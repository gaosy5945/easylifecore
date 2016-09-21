<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%><%
	/*
        Author: undefined 2016-01-11
        Content: 示例详情页面
        History Log: 
    */
	String serialNo = CurPage.getParameter("serialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "InvoiceSignInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","确定","确定","sign()","","","",""},
			{"true","All","Button","取消","取消","top.close();","","","",""}, 
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function sign(){
		if(!iV_all("0")) return ;
		var signName = getItemValue(0,getRow(0),'signName');
		var	signID = getItemValue(0,getRow(0),'signID');
		var signPhone = getItemValue(0,getRow(0),'signPhone');
		var signDate = getItemValue(0,getRow(0),'signDate');
		var record = "<%=serialNo%>"+"&"+signName+"&"+signID+"&"+signPhone+"&"+signDate;
		var result = RunJavaMethod("com.amarsoft.app.als.afterloan.invoice.InvoicePost","InvoiceSign","record="+record);
		if(result=="true")
			alert("签收信息已记录在票据备注中！");
		top.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>