	var ASCheck = {};
	ASCheck.autoCheckFlag = true;
	
	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function sbmt(flowSerialNo,taskSerialNo,phaseNo,flag,functionItemID){
		
		if(typeof(functionItemID) != "undefined" && functionItemID.length != 0)
		{
			try
			{
				ASCheck.autoCheckFlag = null;
				clickTab(functionItemID);
				sleep();
			}catch(e)
			{
				ASCheck.autoCheckFlag = false;
			}
		}
		
		window.setTimeout("submit('"+flowSerialNo+"','"+taskSerialNo+"','"+phaseNo+"','"+flag+"');", 10);
	}
	
	/*~[Describe=合作项目提交任务;InputParam=无;OutPutParam=无;]~*/
	function projectSbmt(flowSerialNo,taskSerialNo,phaseNo,flag,functionItemID){
		
		
		var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckProjectInfo",flowSerialNo);
		if(rValue == "false"){
			alert("请保存项目基本信息！");
			return;
		}
		
		if(typeof(functionItemID) != "undefined" && functionItemID.length != 0)
		{
			try
			{
				ASCheck.autoCheckFlag = null;
				clickTab(functionItemID);
				sleep();
			}catch(e)
			{
				ASCheck.autoCheckFlag = false;
			}
		}
		
		window.setTimeout("submit('"+flowSerialNo+"','"+taskSerialNo+"','"+phaseNo+"','"+flag+"');", 10);
	}
	
	//提交
	function submit(flowSerialNo,taskSerialNo,phaseNo,flag){
		if(ASCheck.autoCheckFlag)
		{
			var rValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.CheckOpinion","run","FlowSerialNo="+flowSerialNo+",TaskSerialNo="+taskSerialNo+",PhaseNo="+phaseNo);
			if(rValue == "false"){
				alert("请签署意见后再提交！");
				return;
			}
			var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo+"&Flag="+flag,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
			{
				return;
			}
			else
			{
				if(returnValue.split("@")[0] == "true")
				{
					/*
					var flowpara = AsCredit.RunJavaMethodTrans("com.amarsoft.app.workflow.action.QueryFlowType","getFlowType","FlowSerialNo="+flowSerialNo+",PhaseNo="+phaseNo);
					flowpara = flowpara.split("@");
					//因为贷后变更流程也有放款监督阶段，此处判断流程是业务申请类流程时才调用自动打印功能. add by bhxiao 20150520
					if(flowpara[0]=="0010"&&(flowpara[1]=="0085"||flowpara[1]=="0090")){
						var returnValue = AsControl.RunASMethod("WorkFlowEngine","GetPutoutNo",flowSerialNo);
						var SerialNos = returnValue.split("@")[0];
						var serialNos = SerialNos.split("~");
						var BusinessTypes = returnValue.split("@")[1];
						var businessTypes = BusinessTypes.split("~");
						var ContractSerialNos = returnValue.split("@")[2];
						var contractSerialNos = ContractSerialNos.split("~");
						for(var i in businessTypes){
							if(typeof businessTypes[i] ==  "string" && businessTypes[i].length > 0 ){
								var businessType = businessTypes[i];
								var serialNo = serialNos[i];
								var contractSerialNo = contractSerialNos[i];
								if(businessType == '666'){//判断为消贷易额度
									AsControl.OpenView("/BillPrint/XdyApplyPass.jsp","SerialNo="+contractSerialNo,"_blank");//消贷易额度及生成贷款规则信息表
								}else if(businessType == '500' || businessType == '502'){ //判断为融资易额度
									AsControl.OpenView("/BillPrint/RzyApplyPass.jsp","SerialNo="+contractSerialNo,"_blank");//融资易额度及生成贷款规则信息表
								}else if(businessType == '555' || businessType == '999'){
									
								}else if(flowpara[1]=="0085"){
									AsControl.OpenView("/BillPrint/LoanFksh.jsp","SerialNo="+serialNo,"_blank");
								}else{
									AsControl.OpenView("/BillPrint/LoanGrant.jsp","SerialNo="+serialNo,"_blank");
								}
							}
						}
					}
					*/
					top.close();
				}
			}
		}
		else
		{
			window.setTimeout("submit('"+flowSerialNo+"','"+taskSerialNo+"','"+phaseNo+"','"+flag+"');", 10);
		}
	}
	
	/*~[Describe=三色预警系统跑批生成任务提交任务;InputParam=无;OutPutParam=无;]~*/
	function sbmtRisk(flowSerialNo,taskSerialNo,phaseNo){
		//三色预警详情页面 是否预警字段
		var isWarning = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskGetIsWarning","getIsWarning","flowSerialNo="+flowSerialNo);
		
		if(isWarning == "0"){//是否预警字段如果为“否”，终止流程；
			var returnValue;
			if(confirm("终止申请后不可恢复，请确认?")){
				returnValue = AsControl.RunASMethod("WorkFlowEngine","TmtPcsInstnc",flowSerialNo);
			}
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
        	if(returnValue.split("@")[0] == "false") alert(returnValue.split("@")[1]);
    		else
    		{
    			alert(returnValue.split("@")[1]);
    			top.close();
    		}
		}else{
			var rValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CheckRiskWarningInfo","CheckRiskWarningInfo","FlowSerialNo="+flowSerialNo);
			if(rValue == "false"){
				alert("请选择预警信号！");
				return;
			}
			var rValueOpinion = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.CheckOpinion","run","FlowSerialNo="+flowSerialNo+",TaskSerialNo="+taskSerialNo+",PhaseNo="+phaseNo);
			if(rValueOpinion == "false"){
				alert("请签署意见后再提交！");
				return;
			}
			var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
			{
				return;
			}
			else
			{
				if(returnValue.split("@")[0] == "true")
				{
					top.close();
				}
			}
		}
	}
	/*~[Describe=三色预警取消任务提交任务;InputParam=无;OutPutParam=无;]~*/
	function sbmtCancel(flowSerialNo,taskSerialNo,phaseNo,serialNo){
		//三色预警详情页面 是否预警字段
		var flag = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskGetIsWarning","getDenyReason","SerialNo="+serialNo);
		if(flag == "0"){//DenyReason字段为空；
			alert("请填写预警解除原因，保存后再提交！");
			return;
		}else{
			window.setTimeout("submit('"+flowSerialNo+"','"+taskSerialNo+"','"+phaseNo+"','"+flag+"');", 10);
		}
	}
	/*~[Describe=资产证券化提交任务;InputParam=无;OutPutParam=无;]~*/
	function securitizationProjectsbmt(flowSerialNo,taskSerialNo,phaseNo){
		//项下是否有资产
		var isAsset = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.ProjectSubmitJudgeAsset","getIsAsset","flowSerialNo="+flowSerialNo);
		if(isAsset == "0"){
			alert("该项目项下没有资产，请导入资产后再提交！");
			return;
		}else{
			var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
			{
				return;
			}
			else
			{
				if(returnValue.split("@")[0] == "true")
				{
					top.close();
				}
			}
		}
	}
	/*~[Describe=退回任务;InputParam=无;OutPutParam=无;]~*/
	function ret(taskSerialNo,flowSerialNo,phaseNo){
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0) return;
		var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckProblem",flowSerialNo+","+phaseNo);
		if(rValue == "false"){
			alert("该任务不存在未处理问题，不可退回！");
			return;
		}
		var returnValue = PopPage("/Common/WorkFlow/ReturnToApndAvyDialog.jsp?TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo,"","dialogWidth:340px;dialogHeight:270px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_")
		{
			return;
		}
		else
		{
			if(returnValue.split("@")[0] == "true")
			{
					top.close();
			}
		}
	}
	/*~[Describe=退回任务（检验退回问题）;InputParam=无;OutPutParam=无;]~*/
	function retu(taskSerialNo,flowSerialNo,phaseNo){
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0) return;
		/*var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckProblemmust",taskSerialNo+","+phaseNo);
		if(rValue == "false"){
		}*/
		var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckIsCallGrade",flowSerialNo+","+phaseNo+","+taskSerialNo);
		if(rValue == "true"){
			alert("您已经调用过评级不能退回！");
			return;
		}
		var returnValue0 = PopPage("/Common/WorkFlow/ReturnReasonInfo.jsp?TaskSerialNo="+taskSerialNo+"&ObjectNo="+flowSerialNo,"","dialogWidth:600px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue0) == "undefined" || returnValue0.length == 0 || returnValue0 == "Null" || returnValue0 == "false"){
			return;
		}
		var returnValue = PopPage("/Common/WorkFlow/ReturnToApndAvyDialog.jsp?TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo,"","dialogWidth:340px;dialogHeight:270px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_")
		{
			return;
		}
		else
		{
			if(returnValue.split("@")[0] == "true")
			{
					top.close();
			}
		}
	}
	
	/*~[Describe=资产证券化退回任务;InputParam=无;OutPutParam=无;]~*/
	function securitizationProjectReturn(taskSerialNo,flowSerialNo,phaseNo){
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0) return;
		var returnValue0 = PopPage("/Common/WorkFlow/ReturnReasonInfo.jsp?TaskSerialNo="+taskSerialNo+"&ObjectNo="+flowSerialNo,"","dialogWidth:600px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue0) == "undefined" || returnValue0.length == 0 || returnValue0 == "Null" || returnValue0 == "false"){
			return;
		}
		var returnValue = PopPage("/ProjectManage/ProjectAssetTransfer/SecuritizationReturnToApndAvyDialog.jsp?TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo,"","dialogWidth:340px;dialogHeight:270px;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_")
		{
			return;
		}
		else
		{
			if(returnValue.split("@")[0] == "true")
			{
					top.close();
			}
		}
	}
	
	function sendMail(objectno,objecttype,userid){
		var rValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.FlowSendApproveMailUserAction", "senMail", "ObjectNo="+objectno+",ObjectType="+objecttype+",UserID="+userid);
		if("Success"!=rValue){
			alert(rValue);
		}else{
			alert("邮件发送成功!");
		}
	}
	
	function runTransaction(){
		var transactionSerialno = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(transactionSerialno) == "undefined" || transactionSerialno.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		//com.amarsoft.app.als.afterloan.change.AfterChangeRun
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterChangeRun","runTransaction","TransactionSerialno="+transactionSerialno);
		if(result=="success"){
			alert("交易执行成功！");
			reloadSelf();
		}else{
			alert(result);
			return;
		}
	}
	
	//贷后变更流程提交成功后，调用打印
	function submitAfterLoan_print(flowSerialNo,taskSerialNo,phaseNo,flag){
		if(ASCheck.autoCheckFlag)
		{
			var rValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.CheckOpinion","run","FlowSerialNo="+flowSerialNo+",TaskSerialNo="+taskSerialNo+",PhaseNo="+phaseNo);
			if(rValue == "false"){
				alert("请签署意见后再提交！");
				return;
			}
			var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo+"&PhaseNo="+phaseNo+"&Flag="+flag,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
			if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
			{
				return;
			}
			else
			{
				if(returnValue.split("@")[0] == "true")
				{
					var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterChangeRun","beforePrintOnFlowSubmit","FlowSerialno="+flowSerialNo);
					if(typeof(result) != "undefined" && result.length > 0) 
					{
						var resultPara = result.split("@");
						var transcode = resultPara[0];
						var transSerialNo = resultPara[3];
						if(transcode == "015005"){
							AsControl.OpenView("/BillPrint/RzyPrepayApply.jsp","SerialNo="+transSerialNo,"_blank");//个人融资易转账退汇资金提前还款通知书
						}
					}
					
					top.close();
				}
			}
		}
		else
		{
			window.setTimeout("submitAfterLoan_print('"+flowSerialNo+"','"+taskSerialNo+"','"+phaseNo+"','"+flag+"');", 10);
		}
	}