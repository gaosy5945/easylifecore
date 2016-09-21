<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.config.impl.TransactionConfig"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/Transaction/Transaction.js"></script>
<%
	String transactionGroup = CurPage.getParameter("TransactionGroup");
	String transactionCode = CurPage.getParameter("TransactionCode");
	String transactionSerialNo = CurPage.getParameter("TransactionSerialNo");
	if(!StringX.isEmpty(transactionSerialNo)){
		BusinessObject transaction = BusinessObjectManager.createBusinessObjectManager(null)
				.loadBusinessObject(transactionGroup, transactionSerialNo);
		if(transaction==null) throw new Exception("不存在的交易流水号！{"+transactionSerialNo+"}");
		
		transactionCode=transaction.getString("TransCode");
	}
	else transactionSerialNo="";

	String templetNo = TransactionConfig.getTransactionConfig(transactionCode, "ViewTempletNo");
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info(templetNo,SystemHelper.getPageComponentParameters(CurPage),CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("TransactionGroup", transactionGroup);
	dwTemp.setParameter("TransactionCode", transactionCode);
	dwTemp.setParameter("TransactionSerialNo", transactionSerialNo);
	dwTemp.genHTMLObjectWindow("");
	
	
	String jsfiles=TransactionConfig.getTransactionConfig(transactionCode, "jsfile");
	String sButtons[][] = {
		{"true","All","Button","保存","保存","saveRecord()","","","",""},
	};
%>

<%
if(!StringX.isEmpty(jsfiles)){
	String[] jsfileArray=jsfiles.split(";");
	for(String jsfile:jsfileArray){
%>
		<script type="text/javascript" src="<%=sWebRootPath+"/"+jsfile%>"></script>
<%
	}
}
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function beforeSave(){
		if("<%=transactionSerialNo%>"==""){
			var productId = getItemValue(0,getRow(),"ProductId");
			var result = AsControl.RunJavaMethod("com.amarsoft.app.als.prd.transaction.script.newproduct.CheckProduct","checkProduct","productId="+productId);
			if(result.split("@")[0] == "false")
				alert(result.split("@")[1]);
			return result.split("@")[0];
		}
		return "true";
	}
	function saveRecord(sPostEvents){
		if(beforeSave() == "false") return;  //公用校验添加
		as_save("openTransactionInfo();");
	}
	
	function openTransactionInfo(){
		//如果是新建交易，简单处理，将新建界面关闭，然后重新打开交易，简单情况下避免重复创建交易。后续待优化
		if("<%=transactionSerialNo%>"==""){
			var outputParameters = ALSObjectWindowFunctions.getOutputParameterObject(0);
			var transactionSerialNo=AsCredit.getBusinessObjectAtrribute(outputParameters,"TransactionSerialNo");
			TransactionFunctions.editTransaction("<%=transactionGroup%>",transactionSerialNo,"","_blank");
			top.close();
		}
		else{
			top.reloadSelf();
		}
	}
	
	if("<%=transactionSerialNo%>"==""){
		window.document.all("sys_sub_page_frame_SPECIFICTAB").style.display = "none";
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
