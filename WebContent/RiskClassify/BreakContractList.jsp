<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String applyStatus=CurPage.getParameter("ApplyStatus");
	String approveStatus=CurPage.getParameter("ApproveStatus");
	String sSerialNo = CurPage.getParameter("SerialNo");
	String sWhereClause = ""; //Where条件
	
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
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("ApplyStatus", applyStatus);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"true","All","Button","处理","处理","deal()","","","","",""},
			{"true","All","Button","取消申请","取消申请","cancel()","","","","",""},
		    {String.valueOf(applyStatus.equals("1")),"","Button","详情","详情","edit()","","","","btn_icon_detail",""},
		  	//{String.valueOf(applyStatus.equals("1")),"","Button","收回","收回","backTask()","","","","btn_icon_detail",""},
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
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}		
	if(!confirm('确实要取消申请吗?')) return;	
	var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","delete","SerialNo="+serialNo);
	alert(returnValue);
	reloadSelf();
}
function edit() {
	var serialNo=getItemValue(0,getRow(),"SerialNo");
	if(typeof(serialNo)=="undefined" || serialNo.length==0) 
	{
		alert(getHtmlMessage('1'));//请选择一条信息！
		return ;
	}
	AsControl.PopComp("/RiskClassify/BreakContractInfo.jsp", "SerialNo="+serialNo);
	reloadSelf();
}
function backTask(){
	var serialNo = getItemValue(0,getRow(0),"SERIALNO");
	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}		
	if(!confirm('确实要收回吗?')) return;	
	var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.BreakContractConfirm","backTask","SerialNo="+serialNo);
	alert(returnValue);
	reloadSelf();
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
