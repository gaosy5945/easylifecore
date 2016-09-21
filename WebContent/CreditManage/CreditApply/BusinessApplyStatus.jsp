<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	String approveStatus = CurPage.getParameter("ApproveStatus");
	ASObjectModel doTemp = new ASObjectModel("BusinessApplyStatus");
	if("04".equals(approveStatus)){
		doTemp.setJboWhere("O.APPROVESTATUS in ('04','06') and O.OperateUserID = :UserID ");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.setParameter("ApproveStatus", approveStatus);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
		{"false","All","Button","复议","复议","add()","","","","",""},
		{"true","","Button","详细信息","详细信息","edit()","","","","",""},
		{"false","All","Button","移除","取消申请","cancel()","","","","",""},
		{"false","All","Button","打印终批意见","打印终批意见","opinion()","","","","",""},
		{"false","All","Button","最终意见","最终意见","opinionLast()","","","","",""},
	};
	if("04".equals(approveStatus))
	{
		sButtons[0][0] = "true";
		sButtons[3][0] = "true";
		sButtons[4][0] = "true";
	}
	if("05".equals(approveStatus))
	{
		sButtons[2][0] = "true";
	}
	if("03".equals(approveStatus))
	{
		sButtons[3][0] = "true";
		sButtons[4][0] = "true";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function opinionLast(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		AsCredit.openFunction("LastApproveInfo","ApplySerialNo="+serialNo+"&RightType=ReadOnly","");
	}
	function opinion(){
		var BusinessType = getItemValue(0,getRow(0),'BusinessType');
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		if(typeof(BusinessType) == "undefined" || BusinessType.length == 0){
			alert("基础产品为空！");//基础产品不能为空！
			return;
		} 
		var PRODUCTTYPE3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType"
				,"ProductID="+BusinessType);
		
		if(PRODUCTTYPE3 == "01" && BusinessType != "555" && BusinessType != "999"){ 
			AsCredit.openFunction("PrintConsumeLoanApprove","SerialNo="+serialNo);//消费类贷款审批意见表
		}else if(PRODUCTTYPE3 == "02"){
			AsControl.OpenView("/BillPrint/BusinessApprove.jsp","SerialNo="+serialNo,"_blank");//经营类贷款审批意见表
		}else if(BusinessType == "555" || BusinessType == "999"){
			AsControl.OpenView("/BillPrint/ApplyDtl1For555.jsp","SerialNo="+serialNo,"_blank");//个人授信额度贷款审批意见表
		}
		
	}
	function add(){
		var serialNo = getItemValue(0,getRow(),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var approveStatus = getItemValue(0, getRow(), "ApproveStatus");
		if(approveStatus == "06"){
			alert("该笔贷款已发起过复议！");
			return;
		}
			
		var isStopApprove = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CheckStopApprove","isStopApprove","applySerialNo="+serialNo);
		if(isStopApprove == "1"){
			alert("本笔贷款不允许发起复议！");
			return;
		}
		
		var CONTRACTARTIFICIALNO = getItemValue(0, getRow(), "CONTRACTARTIFICIALNO");
		var returnValue = PopPage("/CreditManage/CreditApply/BusinessApplyStatusInfo.jsp?SerialNo="+serialNo,"","dialogWidth:550px;dialogHeight:240px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == "false") return;
		if(!confirm("是否确定将合同编号为 "+CONTRACTARTIFICIALNO+" 的贷款发起复议？")) return;
		var orgID = "<%=CurUser.getOrgID()%>";
		var userID = "<%=CurUser.getUserID()%>";
		var objectType = "jbo.app.BUSINESS_APPLY";
		var returnValue1 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.ResderationInfo", "addUser", "SerialNo="+serialNo);
		var SerialNo = returnValue1.split("@")[1];
		var returnValue2 = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.Resderation","run","ApplySerialNo="+SerialNo+",OldApplySerialNo="+serialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		
		alert(returnValue2.split("@")[6]);
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0, getRow(0), "SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//打开页面
		AsCredit.openFunction("ApplyMessageInfo","ObjectNo="+serialNo+"&ObjectType=jbo.app.BUSINESS_APPLY&RightType=ReadOnly","");
	}
	
	/*~[Describe=取消任务;InputParam=无;OutPutParam=无;]~*/
	function cancel(){
		var objectType = "jbo.app.BUSINESS_APPLY";
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.QueryFlowContext","run","ObjectType="+objectType+",ObjectNo="+serialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		
		var flowSerialNo = "";
		if(returnValue.split("@")[0] == "true"){
			flowSerialNo = returnValue.split("@")[3];
		}
		if(typeof(flowSerialNo) == "undefined" || flowSerialNo.length == 0){
			alert("数据有问题，无法移除！");//请选择一条信息！
			return;
		}
		if(!confirm("确认取消申请？")) return;
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.DeleteInstance","run","FlowSerialNo="+flowSerialNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null" || returnValue == null) return;
		if(returnValue.split("@")[0] == "true")
		{
			alert(returnValue.split("@")[1]);
			reloadSelf();
		}
		else
		{
			alert(returnValue.split("@")[1]);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
