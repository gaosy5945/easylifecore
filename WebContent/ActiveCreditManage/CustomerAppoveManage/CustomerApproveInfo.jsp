<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
  
<%
	String BatchNo = CurComp.getParameter("BatchNo");
	if(BatchNo == null) BatchNo = "";
	
	String sTempletNo = "CustomerApprovalInfo";//Ä£°åºÅ
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("BatchNo", BatchNo);
	dwTemp.genHTMLObjectWindow("");
	
	//dwTemp.replaceColumn("CREDITMODEL", "<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"350\" frameborder=\"0\" src=\""+sWebRootPath+"/ActiveCreditManage/CustomerBaseManage/CustomerBaseDoc.jsp?ObjectType="+"jbo.customer.CUSTOMER_INFO"+"&ObjectNo="+CustomerBaseID+"&DocNo="+docNo+"&CompClientID="+sCompClientID+"\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
		{"".equals(BatchNo)?"true":"flase","All","Button","±£´æ","±£´æ","saveRecord()","","","",""}, 
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
function selectCustomerBase(){
	AsDialog.SetGridValue("SelectCustomerBase", "", "CustomerBaseID=CustomerBaseID@CustomerBaseName=CustomerBaseName", "");
}
function selectOrgID()
{
	var returnValue = setObjectValue("SelectAccountBelongOrg","OrgID,<%=CurOrg.getOrgID()%>&FolderSelectFlag=Y","");
	if(typeof(returnValue)=="undefined"||returnValue=="_CANCEL_"
		||returnValue==""||returnValue=="null")
	{
		return;
	}else if(returnValue=="_CLEAR_")
	{
		setItemValue(0, getRow(0), "ApprovalOrgID", "");
		setItemValue(0, getRow(0), "ApprovalOrgName", "");
		return;
	}
	var values = returnValue.split("@");
	setItemValue(0, getRow(0), "ApprovalOrgID", values[0]);
	setItemValue(0, getRow(0), "ApprovalOrgName", values[1]);
}
function saveRecord(){
	as_save(0);
}

function init(){
	setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
	setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
	setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.getOrgID()%>");
	setItemValue(0,getRow(),"InputOrgName","<%=com.amarsoft.dict.als.manage.NameManager.getOrgName(CurOrg.getOrgID())%>");
	setItemValue(0,getRow(),"InputDate","<%=DateHelper.getBusinessDate()%>");
}
init();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 