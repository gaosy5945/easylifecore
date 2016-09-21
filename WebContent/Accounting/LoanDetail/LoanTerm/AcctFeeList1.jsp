<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.app.als.businessobject.*"%> 
<%@include file="/Common/FunctionPage/jspf/MultipleObjectRecourse.jspf" %>
  
<%
	String PG_TITLE = "费用列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	String sObjectNo =CurPage.getParameter("ObjectNo");
	String sObjectType = CurPage.getParameter("ObjectType");
	String status = CurPage.getParameter("Status");//状态
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	

	//显示模版编号
	String templateNo = "AcctFeeList";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", sObjectType);
	inputParameter.setAttributeValue("ObjectNo", sObjectNo);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(templateNo,inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
	String sButtons[][] = {
			{"true", "All", "Button", "新增", "新增一条信息","createFee()",""},
			{"true", "All", "Button", "删除", "删除一条信息","deleteRecord()",""},
			{"true", "", "Button", "详情", "费用详情","viewFee()",""},
			{"false", "", "Button", "费用收取", "费用收取","FeeTransaction('3508')",""},
			{"false", "", "Button", "费用支付", "费用支付","FeeTransaction('3520')",""}
	};
	
	if(sObjectType.equals("PutOutApply")){
		sButtons[0][1]="false";
		sButtons[1][1]="false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf" %>
<script language=javascript>
	/*~[Describe=新建费用;InputParam=无;OutPutParam=无;]~*/
	function createFee(){
		var returnValue = AsDialog.SelectGridValue("SelectComp","FEE%","ComponentID@ComponentName","",false);
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") return;
		
		var termID = returnValue.split("@")[0];
		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.InitApplyObjects","initFee","ObjectType=<%=sObjectType%>,ObjectNo=<%=sObjectNo%>,ComponentID="+compID);
		<%-- var sReturn = RunMethod("LoanAccount","CreateFee",sTermID+",<%=businessObject.getObjectType()%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>"); --%>
		reloadSelf();
	}
	
	function viewFee(){
		var feeSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(feeSerialNo)=="undefined"||feeSerialNo.length==0){
			alert("请选择一条记录");
			return;
		}
		popComp("AcctFeeInfo","/Accounting/LoanDetail/LoanTerm/AcctFeeInfo.jsp","FeeSerialNo="+feeSerialNo,"");
		reloadSelf();
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("确定删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=费用交易;InputParam=无;OutPutParam=无;]~*/
	<%-- function FeeTransaction(transCode){
		var feeSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(feeSerialNo) == "undefined" || feeSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		var transactionSerialNo = RunMethod("LoanAccount","CheckExistsTransaction","<%=BUSINESSOBJECT_CONSTANTS.fee%>,"+feeSerialNo+","+transCode+"");
		if(typeof(transactionSerialNo)=="undefined" || transactionSerialNo.length==0||transactionSerialNo=="Null") {
			//创建不需要流程的交易
			var returnValue = RunMethod("LoanAccount","CreateTransaction",","+transCode+",<%=BUSINESSOBJECT_CONSTANTS.fee%>,"+feeSerialNo+",,<%=CurUser.getUserID()%>,2");
			returnValue = returnValue.split("@");
			transactionSerialNo = returnValue[1];
			if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
				alert("创建交易{"+transCode+"}时失败！错误原因为："+returnValue);
				return;
			}
		}
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&ViewID=000";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		if(confirm("请确认是否进行入账处理！"))
		{
			var returnValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,Y");
			if(typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("系统处理异常！");
				return;
			}
			var message=returnValue.split("@")[1];
			alert(message);
			reloadSelf();
		}
	} --%>
</script>
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>