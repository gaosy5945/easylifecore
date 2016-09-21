<%@page import="com.amarsoft.app.als.awe.ow2.ObjectWindowManager"%>
<%@page import="com.amarsoft.app.als.awe.ow2.config.ObjectWindowFactory"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@page import="com.amarsoft.app.als.transaction.config.TransactionConfig"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/Transaction/Transaction.js"></script>
<%
	String transactionGroup = CurPage.getParameter("TransactionGroup");
	String transactionCode = CurPage.getParameter("TransactionCode");
	String transactionSerialNo = CurPage.getParameter("TransactionSerialNo");
	if(!StringX.isEmpty(transactionSerialNo)){
		BusinessObject transaction = BusinessObjectManager.createBusinessObjectManager()
				.loadBusinessObject(transactionGroup, transactionSerialNo);
		if(transaction==null) throw new Exception("�����ڵĽ�����ˮ�ţ�{"+transactionSerialNo+"}");
		
		String transactionCodeAttributeID = TransactionConfig.getGroupAttribute(transactionGroup, "TransactionCodeAttributeID"); 
		if(StringX.isEmpty(transactionCodeAttributeID)) transactionCodeAttributeID="TransCode";
		transactionCode=transaction.getString(transactionCodeAttributeID);
	}
	else transactionSerialNo="";

	String templetNo = TransactionConfig.getAttribute(transactionGroup, transactionCode, "InputInfoTempletNo");
	ObjectWindowManager owmanager = ObjectWindowFactory.getFactory().getObjectWindowManager(templetNo);
	ASObjectWindow dwTemp =owmanager.genObjectWindow("All", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.genHTMLObjectWindow("");
	
	String jsfiles=owmanager.getObjectWindowConfig().getBusinessObjectValue("manager").getString("jsfile");
	String sButtons[][] = {
		{"true","All","Button","����","����","saveRecord()","","","",""},
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
	function saveRecord(sPostEvents){
		as_save("openTransactionInfo();");
	}
	
	function openTransactionInfo(){
		//������½����ף��򵥴������½�����رգ�Ȼ�����´򿪽��ף�������±����ظ��������ס��������Ż�
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
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
