<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	/*
		Author:   qzhang  2004/12/02
		Tester:
		Content: ��ͬ��Ϣ�б�
		Input Param:	 
		Output param:
		History Log: 
	*/
	String sSerialNo =  DataConvert.toString(CurPage.getParameter("SerialNo"));
	String sCustomerId =  DataConvert.toString(CurPage.getParameter("CustomerId"));
	String sRightType =  DataConvert.toString(CurPage.getParameter("RightType"));
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerId == null) sCustomerId = "";

	String sTempletNo = "ContractInterviewInfo";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(sSerialNo);
	
	//dwTemp.replaceColumn("CHECKINFO", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"220\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditManage/CreditContract/ContractFileCheckList.jsp?ObjectNo="+sSerialNo+"&ObjectType=jbo.app.BUSINESS_CONTRACT&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("UPLOADFILE", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"200\" frameborder=\"0\" src=\""+sWebRootPath+"/Common/BusinessObject/BusinessObjectDocumentList.jsp?ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+sSerialNo+"&RightType="+sRightType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	dwTemp.replaceColumn("RECORDRESULT", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/CreditManage/CreditContract/SignResultInfo.jsp?ObjectNo="+sSerialNo+"&ObjectType=jbo.app.BUSINESS_CONTRACT&RightType="+sRightType+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {

		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		var sCustomerName = getItemValue(0,0,"CUSTOMERNAME");
		var sOperateUserName = getItemValue(0,0,"OPERATEUSERNAME");		
		setItemValue(0,0,"SIGNPEOPLE",sCustomerName+"��"+sOperateUserName);
	}

</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
