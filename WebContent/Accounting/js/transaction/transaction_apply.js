
var TransactionApply={
		
};
var tempTransCode = "";

/**
 * 新增交易申请
 */
function createTask(){
	//将参数存为开头结尾均有,号
	var sTransactionFilter = ","+AsCredit.parameter["TransactionFilter"]+",";
	
	
	if(sTransactionFilter.indexOf(",") < 0 && sTransactionFilter.trim().length() > 0 && !sTransactionFilter.trim().toUpperCase().equals("ALL")){
		var transactionCode = sTransactionFilter;
		//var transObjectSelector = RunJavaMethod("com.amarsoft.app.accounting.config.loader.TransactionConfig","getTransactionDef","transactionCode="+transactionCode);
	    //如何实现？？
	}else{
		//将sTransactionFilter中所有的“，”替换为"@"
		var sLTransactionFilter = sTransactionFilter.replace(/,/g,"@");
		
		var paraString = "TransactionFilter,"+sLTransactionFilter+",UserID,"+AsCredit.userId;
		var returnValue = setObjectValue("SelectTransactionCode",paraString,"",0,0,"");
		if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
		{
			return;
		}
		
		returnValue = returnValue.split("@");
		var transactionCode = returnValue[0];
		tempTransCode = transactionCode;
	}
	var relativeObjectType = "";
	var relativeObjectNo = "";
	var transObjectSelector = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue", "getColValue", "colName="+Attribute5+",tableName="+"CODE_LIBRARY,whereClause=String@CodeNo@T_Transaction_Def@String@ItemNo@"+transactionCode);
 
	if(typeof(transObjectSelector) == "undefined" || transObjectSelector.length == 0){
		relativeObjectType = "";
		relativeObjectNo = ""; 

		return;
	}
	else{		    

		try{
			var returnValue = eval(transObjectSelector.split("@")[1]);
			if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_CANCEL_" || returnValue == "_CLEAR_"){
				return;
			}
			relativeObjectType = returnValue.split("@")[0];
			relativeObjectNo = returnValue.split("@")[1];
		}
		catch(e){
			//alert("交易{"+transactionCode+"}定义的对象选择器调用失败，请检查Code_Library的Attribute5!");
			return;
		}
	}

	//modify begin add by zmxu 20120806 控制交易申请但未执行成功的各种交易不能重复申请
	var allowApplyFlag = RunJavaMethodTrans("com.amarsoft.acct.accounting.web.GetAllowApplyFlag","getAllowApplyFlag","transactionCode="+transactionCode+
			",relativeObjectType="+relativeObjectType+",relativeObjectNo="+relativeObjectNo);
	if(allowApplyFlag != "true")
	{
		alert("该业务已经存在一笔未生效的交易记录，不允许同时申请！");
		return;
	}
	//modify end
	var objectType=AsCredit.parameter["ApplyType"];

	var returnValue = RunJavaMethodTrans("com.amarsoft.acct.accounting.web.CreateTransaction","createTransaction","transactionCode="+transactionCode+
			",relativeObjectType="+relativeObjectType+",relativeObjectNo="+relativeObjectNo)+",transactionDate="+AsCredit.today+",userID"+AsCredit.userId;
 	if(returnValue.substring(0,5) != "true@") {
		alert("创建交易失败！错误原因-"+returnValue);
		return;
	}
	returnValue = returnValue.split("@");
	var transactionSerialNo = returnValue[1];
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
		alert("创建交易失败！错误原因-"+returnValue);
		return;
	}
	var sParamString = "ObjectType=Transaction"+"&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&ApplyType="+AsCredit.parameter["ApplyType"];
	AsCredit.openFunction("TransactionApplyDetail",sParamString);
	
/*	sCompID = "CreditTab";
	sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
	sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";

	OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);*/
	
	reloadSelf();	
	
}


/**
 * 交易申请详情
 */
function viewTask(){
	//获得申请类型、申请流水号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sTransCode = getItemValue(0,getRow(),"TransCode");
	var sApplyType = getItemValue(0,getRow(),"ApplyTYpe");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	
/*	sCompID = "CreditTab";
	sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
	sParamString = "ObjectType=Transaction&ObjectNo="+sObjectNo;
	OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	reloadSelf();*/
	
	var sParamString = "ObjectType=Transaction"+"&ObjectNo="+sObjectNo+"&TransCode="+sTransCode+"&ApplyType="+sApplyType;
	AsCredit.openFunction("TransactionApplyDetail",sParamString);
	//reloadSelf();	
}

/**
 * 取消交易申请
 */
function cancelApply(){
	//获得申请类型、申请流水号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	if(confirm(getHtmlMessage('70'))){
		as_delete(0,'','delete');
		as_do(0,'','save');  //如果单个删除，则要调用此语句
	}   //!!问题：无法删除表ACCT_TRANSACTION中的记录
	reloadSelf();//解决连续多次取消时报错
}

/**
 * 签署意见
 */
function signOpinion(){
	//获得申请类型、申请流水号、流程编号、阶段编号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}

	//获取任务流水号
	var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+AsCredit.userId);
	if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
		alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
		return;
	}
	
	/*sCompID = "SignTaskOpinionInfo";
	sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
	popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");*/
	
	sStyle="dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
	AsCredit.openFunction("SignTaskOpinionInfo","TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,sStyle);
	reloadSelf();
}


/**
 *提交
 */
function doSubmit(){
	//获取参数sApplyType1申请类型
	//获得申请类型、申请流水号、流程编号、阶段编号、申请类型
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sApplyType1 = AsCredit.parameter["ApplyType"];
	var sOccurType=getItemValue(0,getRow(),"OccurType");
	var sTransCode = getItemValue(0,getRow(),"TransCode");
	
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}

	//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
	var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);		
	if(sNewPhaseNo != sPhaseNo) {
		alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
		reloadSelf();
		return;
	}

	//获取任务流水号
	var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+AsCredit.userId);
	if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
		alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
		return;
	} 
	
	//进行风险智能探测
	
/*	var sReturn = autoRiskScan("017","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ApplyType1="+sApplyType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo+"&TransCode="+sTransCode);
	if(sReturn != true){
		return;
	}*/

	//弹出审批提交选择窗口		
	var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
	else if (sPhaseInfo == "Success"){
		alert(getHtmlMessage('18'));//提交成功！
		reloadSelf();
	}else if (sPhaseInfo == "Failure"){
		alert(getHtmlMessage('9'));//提交失败！
		return;
	}else{
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//如果提交成功，则刷新页面
		if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}
	}
}


/**
 * 查看意见
 */
function viewOpinions(){
	//获得申请类型、申请流水号、流程编号、阶段编号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	
	popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
}

/*~[Describe=选择贷款信息;InputParam=无;OutPutParam=无;]~*/
function selectTransObject(objectType,selectorname)//选择贷款
{
	var s=setObjectValue(selectorname,"OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return objectType+"@"+serialNo;
}

function SelectFeeRecieve()//选择收取费用
{
	var sTransCode = tempTransCode;
	tempTransCode = "";
	
	var s = setObjectValue("SelectFeeRecieve","OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_FEE@"+serialNo;
}

function SelectFeePay()//选择支付费用
{
	var sTransCode = tempTransCode;
	tempTransCode = "";
	
	var s = setObjectValue("SelectFeePay","OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_FEE@"+serialNo;
}

function SelectWaiveFee()
{
	var s=setObjectValue("SelectWaiveFee","OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_FEE@"+serialNo;

}

function SelectRefundFee()
{
	var s=setObjectValue("SelectRefundFee","OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_FEE@"+serialNo;

}

function selectTransaction(TransCode)//选择原交易
{
	alert(TransCode);
	var s=setObjectValue("SelectStrikeTransaction","OrgID,"+AsCredit.orgId+",TransCode,"+TransCode,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_TRANSACTION@"+serialNo;

}

/**
 * 收回
 */
function takeBack(){
	//所收回任务的流水号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = RunMethod("WorkFlowEngine","GetInitPahseNo",sObjectType+","+sObjectNo);
	//获取任务流水号
	var sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
	if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0){
		if(confirm(getBusinessMessage('498'))){ //确认收回该笔业务吗？
			sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//收回成功后才刷新页面
			if(sRetValue == "Commit"){
				reloadSelf();
			}
		}
	}else{
		alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
		return;
	}				
}


/**
 * 保存申请信息
 */
function saveRecord(){
	if(!iV_all("0")) return;
	as_save("myiframe0");
/*	//if( !confirm("确定保存该信息吗?")) return;
	alert(!beforeSave());
	if(!beforeSave()) return;  //公用校验添加
	  as_save("0","afterSave()");*/
}