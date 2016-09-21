<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String applyStatus=CurPage.getParameter("ApplyStatus");
	String approveStatus=CurPage.getParameter("ApproveStatus");
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sWhereClause = ""; //Where����
	
	if(applyStatus == null) applyStatus = "";
	if(approveStatus == null) approveStatus = "";
	if(sSerialNo == null) sSerialNo = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("UserID", CurUser.getUserID());
	inputParameter.setAttributeValue("OrgID", CurUser.getOrgID());
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("BreakContractList",inputParameter,CurPage);
	
	if(applyStatus=="1" || "1".equals(applyStatus)){
		sWhereClause = "  and O.ApproveStatus= '" + approveStatus + "' ";	
	} 
	
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereClause);	
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	
	ASObjectWindow  dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("ApplyStatus", applyStatus);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","All","Button","����","����","deal()","","","","",""},
			{"true","All","Button","ȡ������","ȡ������","cancel()","","","","",""},
		    {String.valueOf(applyStatus.equals("1")),"","Button","����","����","edit()","","","","btn_icon_detail",""},
		  	//{String.valueOf(applyStatus.equals("1")),"","Button","�ջ�","�ջ�","backTask()","","","","btn_icon_detail",""},
			};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function add(){	
	var userID = "<%=CurUser.getUserID()%>";
	var orgID = "<%=CurUser.getOrgID()%>";
	
	var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
    var returnValue = AsDialog.SelectGridValue('BreakContractSelectList',"<%=CurUser.getOrgID()%>,<%=CurUser.getUserID()%>",'SERIALNO','',sStyle);
    if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
		return ;
    
    var returnValue1 = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","create","duebillSerialNo="+returnValue+",UserID="+userID+",OrgID="+orgID);
    AsCredit.openFunction("BreakConfirmApply","SerialNo="+returnValue1+"&DuebillNo="+returnValue);	
    reloadSelf();
}
function deal(){
	var serialNo = getItemValue(0,getRow(0),"SERIALNO");
	var bdSerialNo = getItemValue(0,getRow(0),"BDSERIALNO");
	AsCredit.openFunction("BreakConfirmApply","SerialNo="+serialNo+"&DuebillNo="+bdSerialNo);			
	reloadSelf();
}
function cancel(){
	var serialNo = getItemValue(0,getRow(0),"SERIALNO");
	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}		
	if(!confirm('ȷʵҪȡ��������?')) return;	
	var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","delete","SerialNo="+serialNo);
	alert(returnValue);
	reloadSelf();
}
function edit() {
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	if(typeof(serialNo)=="undefined" || serialNo.length==0) 
	{
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	}
	AsControl.PopComp("/RiskClassify/BreakContractInfo.jsp", "SerialNo="+serialNo);
	reloadSelf();
}
function backTask(){
	var serialNo = getItemValue(0,getRow(0),"SERIALNO");
	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}		
	if(!confirm('ȷʵҪ�ջ���?')) return;	
	var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","backTask","SerialNo="+serialNo);
	alert(returnValue);
	reloadSelf();
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
