var CreditLineManage={};
//��������ύ
CreditLineManage.updateCLAndTodoStatus=function(serialNo,TodoStatus,CLStatus,CLSerialNo,COSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.UpdateCLAndTodoStatus", "updateCLAndTodoStatus", "SerialNo="+serialNo+",TodoStatus="+TodoStatus+",CLStatus="+CLStatus+",CLSerialNo="+CLSerialNo+",COSerialNo="+COSerialNo);
	return result;
};
//��ѯ�ñ������Ƿ���������
CreditLineManage.selectCLTasking=function(serialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.SelectCLTasking", "selectCLTasking", "SerialNo="+serialNo);
	return result;
};
//�����������ύ
CreditLineManage.importCOAndTodoStatus=function(CLSerialNo,TodoType,operateType,reason,preStatus,operateOrgID,operateUserID,inputUserID,inputOrgID,inputDate){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.ImportCOAndTodoStatus", "importCOAndTodoStatus", "CLSerialNo="+CLSerialNo+",TodoType="+TodoType+",OperateType="+operateType+",Reason="+reason+",PreStatus="+preStatus+",OperateOrgID="+operateOrgID+",OperateUserID="+operateUserID+",InputUserID="+inputUserID+",InputOrgID="+inputOrgID+",InputDate="+inputDate);
	return result;
};
//ȡ������������
CreditLineManage.cancelCLApply=function(CLSerialNo){
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.CancelCLApply", "cancelCLApply", "CLSerialNo="+CLSerialNo);
	return result;
};
//ȡ������������
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
	if(!confirm("ȷ��Ҫ�ύ��")){
		return;
	}
	
	var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.UpdateStatus", "submitApply", "SerialNo="+SerialNo+",Status="+status);
	if(result == "SUCCEED"){
		if("2"==status){
			alert("���ύ�����зſ�ڣ�");			
		}else{
			alert("���������ɣ�");
		}
		
		top.close();
	}else{
		alert(result);
		return;
	}
}

