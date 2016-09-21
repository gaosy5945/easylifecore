var CreditLineManage={};
//额度审批提交
CreditLineManage.updateCLAndTodoStatus=function(serialNo,TodoStatus,CLStatus,CLSerialNo,COSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.UpdateCLAndTodoStatus", "updateCLAndTodoStatus", "SerialNo="+serialNo+",TodoStatus="+TodoStatus+",CLStatus="+CLStatus+",CLSerialNo="+CLSerialNo+",COSerialNo="+COSerialNo);
	return result;
};
//查询该笔任务是否在流程中
CreditLineManage.selectCLTasking=function(serialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.SelectCLTasking", "selectCLTasking", "SerialNo="+serialNo);
	return result;
};
//额度申请操作提交
CreditLineManage.importCOAndTodoStatus=function(CLSerialNo,TodoType,operateType,reason,preStatus,operateOrgID,operateUserID,inputUserID,inputOrgID,inputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.ImportCOAndTodoStatus", "importCOAndTodoStatus", "CLSerialNo="+CLSerialNo+",TodoType="+TodoType+",OperateType="+operateType+",Reason="+reason+",PreStatus="+preStatus+",OperateOrgID="+operateOrgID+",OperateUserID="+operateUserID+",InputUserID="+inputUserID+",InputOrgID="+inputOrgID+",InputDate="+inputDate);
	return result;
};
//取消额度申请操作
CreditLineManage.cancelCLApply=function(CLSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.CancelCLApply", "cancelCLApply", "CLSerialNo="+CLSerialNo);
	return result;
};
//取消额度申请操作
CreditLineManage.updateCLLose=function(CLSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.UpdateStatus", "updateCLLose", "CLSerialNo="+CLSerialNo);
	return result;
};

CreditLineManage.importCLStopApply=function(CLSerialNo,preStatus,inputOrgID,inputUserID,inputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.ImportCLStopApply", "importCOStatus", "CLSerialNo="+CLSerialNo+",PreStatus="+preStatus+",InputOrgID="+inputOrgID+",InputUserID="+inputUserID+",InputDate="+inputDate);
	return result;
};

CreditLineManage.checkCL=function(CLSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.UpdateStatus", "checkCL", "SerialNo="+CLSerialNo);
	return result;
}

function submitApply(SerialNo,status){
	if(!confirm("确定要提交吗？")){
		return;
	}
	
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.UpdateStatus", "submitApply", "SerialNo="+SerialNo+",Status="+status);
	if(result == "SUCCEED"){
		if("2"==status){
			alert("已提交至本行放款岗！");			
		}else{
			alert("额度审批完成！");
		}
		
		top.close();
	}else{
		alert(result);
		return;
	}
}

