	var ASCheck = {};
	ASCheck.autoCheckFlag = true;
	
	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
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
	
	/*~[Describe=������Ŀ�ύ����;InputParam=��;OutPutParam=��;]~*/
	function projectSbmt(flowSerialNo,taskSerialNo,phaseNo,flag,functionItemID){
		
		
		var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckProjectInfo",flowSerialNo);
		if(rValue == "false"){
			alert("�뱣����Ŀ������Ϣ��");
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
	
	//�ύ
	function submit(flowSerialNo,taskSerialNo,phaseNo,flag){
		if(ASCheck.autoCheckFlag)
		{
			var rValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.CheckOpinion","run","FlowSerialNo="+flowSerialNo+",TaskSerialNo="+taskSerialNo+",PhaseNo="+phaseNo);
			if(rValue == "false"){
				alert("��ǩ����������ύ��");
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
					//��Ϊ����������Ҳ�зſ�ල�׶Σ��˴��ж�������ҵ������������ʱ�ŵ����Զ���ӡ����. add by bhxiao 20150520
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
								if(businessType == '666'){//�ж�Ϊ�����׶��
									AsControl.OpenView("/BillPrint/XdyApplyPass.jsp","SerialNo="+contractSerialNo,"_blank");//�����׶�ȼ����ɴ��������Ϣ��
								}else if(businessType == '500' || businessType == '502'){ //�ж�Ϊ�����׶��
									AsControl.OpenView("/BillPrint/RzyApplyPass.jsp","SerialNo="+contractSerialNo,"_blank");//�����׶�ȼ����ɴ��������Ϣ��
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
	
	/*~[Describe=��ɫԤ��ϵͳ�������������ύ����;InputParam=��;OutPutParam=��;]~*/
	function sbmtRisk(flowSerialNo,taskSerialNo,phaseNo){
		//��ɫԤ������ҳ�� �Ƿ�Ԥ���ֶ�
		var isWarning = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskGetIsWarning","getIsWarning","flowSerialNo="+flowSerialNo);
		
		if(isWarning == "0"){//�Ƿ�Ԥ���ֶ����Ϊ���񡱣���ֹ���̣�
			var returnValue;
			if(confirm("��ֹ����󲻿ɻָ�����ȷ��?")){
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
				alert("��ѡ��Ԥ���źţ�");
				return;
			}
			var rValueOpinion = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.CheckOpinion","run","FlowSerialNo="+flowSerialNo+",TaskSerialNo="+taskSerialNo+",PhaseNo="+phaseNo);
			if(rValueOpinion == "false"){
				alert("��ǩ����������ύ��");
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
	/*~[Describe=��ɫԤ��ȡ�������ύ����;InputParam=��;OutPutParam=��;]~*/
	function sbmtCancel(flowSerialNo,taskSerialNo,phaseNo,serialNo){
		//��ɫԤ������ҳ�� �Ƿ�Ԥ���ֶ�
		var flag = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.RiskGetIsWarning","getDenyReason","SerialNo="+serialNo);
		if(flag == "0"){//DenyReason�ֶ�Ϊ�գ�
			alert("����дԤ�����ԭ�򣬱�������ύ��");
			return;
		}else{
			window.setTimeout("submit('"+flowSerialNo+"','"+taskSerialNo+"','"+phaseNo+"','"+flag+"');", 10);
		}
	}
	/*~[Describe=�ʲ�֤ȯ���ύ����;InputParam=��;OutPutParam=��;]~*/
	function securitizationProjectsbmt(flowSerialNo,taskSerialNo,phaseNo){
		//�����Ƿ����ʲ�
		var isAsset = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.ProjectSubmitJudgeAsset","getIsAsset","flowSerialNo="+flowSerialNo);
		if(isAsset == "0"){
			alert("����Ŀ����û���ʲ����뵼���ʲ������ύ��");
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
	/*~[Describe=�˻�����;InputParam=��;OutPutParam=��;]~*/
	function ret(taskSerialNo,flowSerialNo,phaseNo){
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0) return;
		var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckProblem",flowSerialNo+","+phaseNo);
		if(rValue == "false"){
			alert("�����񲻴���δ�������⣬�����˻أ�");
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
	/*~[Describe=�˻����񣨼����˻����⣩;InputParam=��;OutPutParam=��;]~*/
	function retu(taskSerialNo,flowSerialNo,phaseNo){
		if(typeof(taskSerialNo) == "undefined" || taskSerialNo.length == 0) return;
		/*var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckProblemmust",taskSerialNo+","+phaseNo);
		if(rValue == "false"){
		}*/
		var rValue = AsControl.RunASMethod("WorkFlowEngine","CheckIsCallGrade",flowSerialNo+","+phaseNo+","+taskSerialNo);
		if(rValue == "true"){
			alert("���Ѿ����ù����������˻أ�");
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
	
	/*~[Describe=�ʲ�֤ȯ���˻�����;InputParam=��;OutPutParam=��;]~*/
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
			alert("�ʼ����ͳɹ�!");
		}
	}
	
	function runTransaction(){
		var transactionSerialno = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(transactionSerialno) == "undefined" || transactionSerialno.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//com.amarsoft.app.als.afterloan.change.AfterChangeRun
		var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.change.AfterChangeRun","runTransaction","TransactionSerialno="+transactionSerialno);
		if(result=="success"){
			alert("����ִ�гɹ���");
			reloadSelf();
		}else{
			alert(result);
			return;
		}
	}
	
	//�����������ύ�ɹ��󣬵��ô�ӡ
	function submitAfterLoan_print(flowSerialNo,taskSerialNo,phaseNo,flag){
		if(ASCheck.autoCheckFlag)
		{
			var rValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.workflow.action.CheckOpinion","run","FlowSerialNo="+flowSerialNo+",TaskSerialNo="+taskSerialNo+",PhaseNo="+phaseNo);
			if(rValue == "false"){
				alert("��ǩ����������ύ��");
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
							AsControl.OpenView("/BillPrint/RzyPrepayApply.jsp","SerialNo="+transSerialNo,"_blank");//����������ת���˻��ʽ���ǰ����֪ͨ��
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