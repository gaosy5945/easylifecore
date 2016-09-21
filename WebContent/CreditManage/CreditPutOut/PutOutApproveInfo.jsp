<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String flowSerialNo = CurPage.getParameter("FlowSerialNo");
	String taskSerialNo = CurPage.getParameter("TaskSerialNo");
	String flowNo = CurPage.getParameter("FlowNo");
	String flowVersion = CurPage.getParameter("FlowVersion");
	String phaseNo = CurPage.getParameter("PhaseNo");
	String contractSerialNo = CurPage.getParameter("ContractSerialNo");
	
	//将空值转化成空字符串
    if(flowSerialNo == null) flowSerialNo = "";
    if(taskSerialNo == null) taskSerialNo = "";
    if(flowNo == null) flowNo = "";
    if(flowVersion == null) flowVersion = "";
    if(phaseNo == null) phaseNo = "";
    if(contractSerialNo == null) contractSerialNo = ""; 

	String sTempletNo = "PutoutCheck";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.genHTMLObjectWindow(taskSerialNo);

	dwTemp.replaceColumn("PUTOUTCHECK","<iframe type='iframe' id=\"PUTOUTCHECK\" name=\"PUTOUTCHECK\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditManage/CreditPutOut/PutOutConditionList.jsp?ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+contractSerialNo+"&CompClientID="+sCompClientID+"\"></iframe>",CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("CONTRACTCHECK","<iframe type='iframe' id=\"CONTRACTCHECK\" name=\"CONTRACTCHECK\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditManage/CreditPutOut/ContractFileCheck.jsp?TaskSerialNo="+taskSerialNo+"&ObjectType="+objectType+"&ObjectNo="+objectNo+"&CompClientID="+sCompClientID+"\"></iframe>",CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("ACCOUNTCHECK","<iframe type='iframe' id=\"ACCOUNTCHECK\" name=\"ACCOUNTCHECK\" width=\"300%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp?Status=0&ObjectType="+objectType+"&ObjectNo="+objectNo+"&CompClientID="+sCompClientID+"\"></iframe>",CurPage.getObjectWindowOutput());
	//dwTemp.replaceColumn("CHECKRESULT","<iframe type='iframe' id=\"CHECKRESULT\" name=\"CHECKRESULT\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditManage/CreditPutOut/PutOutCheckResult.jsp?TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo+"&CompClientID="+sCompClientID+"\"></iframe>",CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
		
	};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">


</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
