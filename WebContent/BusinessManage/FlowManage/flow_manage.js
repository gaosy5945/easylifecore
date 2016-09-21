/**
 * ������ص�js�ļ�,���������̶���Ĺ���
 * AsTask һ��������
 * AsNotic  ֪ͨ����
 * AsTaskView ������
 * AsReport  ��ʽ������
 * AsOpinion ǩ��������JS ������
 * @author cjyu 
 */

/**
 * ���̶���
 * ���������̵��ύ���˻صȳ��ò���
 */
var AsTask={
	/**��ȡ��ǰ������ˮ��*/
	getInitTaskNo:function(objectNo,objectType){
		var taskNo = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getInitTaskNo","ObjectNo="+objectNo+",ObjectType="+objectType);
		if(!taskNo) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		} 
		return taskNo;
	},
	//��ȡ��ǰ������ˮ��
	getCurTaskNo:function(objectNo,objectType,userID){
		var taskNo = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getUnFinishedTaskNo","ObjectNo="+objectNo+",ObjectType="+objectType+",UserID="+userID);
		if(!taskNo) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		} 
		return taskNo;
	},
	//��ȡ��ǰ����״̬
	getCurFlowState:function(taskNo){
		var curFlowState = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getTaskFlowState","TaskNo="+taskNo);
		return curFlowState;
	},
	//����Ƿ��Ѿ��ύ
	checkIsSubmit:function(taskNo) {
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsSubmit","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//�жϵ�ǰ�׶��Ƿ���Ҫǩ�����
	checkIsSign:function(taskNo) {
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsSign","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//�жϵ�ǰ�׶��Ƿ�ָ���ύ�׶�
	checkIsAssigned:function(taskNo) {
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsAssigned","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//����Ƿ���ҪӰ������
	checkIsImageView:function(taskNo) {
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsImageView","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//����Ƿ�ǩ�����
	checkIsOpinion:function(taskNo) {
		if(this.checkIsSign(taskNo)){
			var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsOpinion","TaskNo="+taskNo);
			if(returnValue == "true"){
				return true;
			}else{
				return false;
			}
		}else{
			return true;
		}
	},
	//�ж��Ƿ������Ǽǽ׶�
	checkIsApprovePhase:function(taskNo){
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsApprovePhase","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//�鿴����ͼ
	viewFlowGraph:function(taskNo){
		 AsControl.PopView("/Frame/ShowFlowInst.jsp","TaskNo="+taskNo,"dialogWidth=800px;dialogHeight=600px");
	},	
	//�����ύ
	doTaskSubmit:function(taskNo){
		if(this.checkIsSubmit(taskNo)){
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			return "Working";
		}
		var curFlowState = this.getCurFlowState(taskNo); 
		if(curFlowState == "SUPPLY"){//��������
			var phaseOpinion = "������ȫ";
			var phaseAction = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","getToSupplyUserID","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion);
			if(!phaseAction){
				alert("���������ύ�û�Ϊ��");
				return;
			}
			return this.doSupplyTask(taskNo,phaseAction,phaseOpinion);
		}else if(curFlowState == "MEETING"){
			return this.doVoteTask(taskNo,"NOTICEVOTE");
		}
		//���������ύѡ�񴰿�/Common/WorkFlow/SubmitDialogNew.jsp		
		var returnValue = AsControl.PopComp("/Common/FlowManage/FlowSubmitDialog.jsp","TaskNo="+taskNo,"dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//A3Web�ύҳ���߼�
		//var returnValue = AsControl.PopComp("/Common/WorkFlow/SubmitDialogNew.jsp","TaskNo="+taskNo,"dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(!returnValue || returnValue == "_CANCEL_") return returnValue;
		else if (returnValue == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
		}else if (returnValue == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
		}else if(returnValue == "Working"){
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
		}
		return returnValue;
	},
	//�����ύ
	doSubmit:function(objectNo,objectType,userID){
		var taskNo = this.getCurTaskNo(objectNo,objectType,userID);
		if(this.checkIsSubmit(taskNo)){
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}else{
			var curFlowState = this.getCurFlowState(taskNo); 
			if(curFlowState == "SUPPLY"){//��������
				var phaseOpinion = "������ȫ";
				var phaseAction = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","getToSupplyUserID","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion);
				if(!phaseAction){
					alert("���������ύ�û�Ϊ��");
					return;
				}
				return this.doSupplyTask(taskNo,phaseAction,phaseOpinion);
			}else if(curFlowState == "MEETING"){
				return this.doVoteTask(taskNo,"NOTICEVOTE");
			}
			return this.doTaskSubmit(taskNo);
		}
	},
	//ָ���ύ�����߼����
	doAssignedTask:function(taskNo){
		//�ж��Ƿ���ָ���ύ�׶�
		if(this.checkIsAssigned(taskNo)){
			var assignedTaskInfo = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getAssignedTaskInfo","TaskNo="+taskNo);
			if(!assignedTaskInfo && assignedTaskInfo != "@@"){
				var assignedTaskNo = assignedTaskInfo.split("@")[0];
				var assignedTaskPhaseInfo = assignedTaskInfo.split("@")[1];
				var nextAssignedTaskNo = assignedTaskInfo.split("@")[2];
				if(!confirm("�ñ�ҵ���Ѿ�ָ���ύ�׶Ρ�"+assignedTaskPhaseInfo+"\r\n��ȷ���ύ��")) return;
				var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","commitTask","TaskNo="+taskNo);
				if (returnValue == "Success"){
					alert(getHtmlMessage('18'));//�ύ�ɹ���
				}else if (returnValue == "Failure"){
					alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				}else if(returnValue == "Working"){
					alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
				}
				return returnValue;
			}
		}
	},
	doSupplyTask:function(taskNo,phaseAction,phaseOpinion){
		if(!confirm("�ñ�ҵ��ȷ�ϲ�����ȫ�ύ��")) return; 
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","commitTask","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion+",PhaseAction="+phaseAction);
		return returnValue;
	},
	doVoteTask:function(taskNo,phaseAction){
		if(!confirm("�ñ�ҵ��ȷ�����ͶƱ��")) return; 
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","finishVoteTask","TaskNo="+taskNo+",PhaseAction="+phaseAction);
		return returnValue;
	},
	//��ʼ���׶��ջ�
	takeBackToInit:function(objectNo,objectType,userID){
		if(!confirm(getBusinessMessage('498'))) return; //ȷ���ջظñ�ҵ����
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","takeBackToInit","ObjectNo="+objectNo+",ObjectType="+objectType+",UserID="+userID);
		//�ջسɹ����ˢ��ҳ��
		alert(returnValue);
		return returnValue;
	},
	//�����׶��ջ�
	takeBackToCur:function(taskNo,userID){
		if(!confirm(getBusinessMessage('498'))) return; //ȷ���ջظñ�ҵ����
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","takeBackToCur","TaskNo="+taskNo+",UserID="+userID);
		alert(returnValue);
		return returnValue;
	},
	//�˻���һ��
	backStep:function(taskNo,userID){
		//�ݲ��������ˣ������Ż�����TBF99
		var flowState = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getTaskFlowState","TaskNo="+taskNo);
		if(flowState == "BACK"){
			alert("�����������˻����񣬲����ٴ��˻�");
			return;
		}
		if(!confirm(getBusinessMessage('509'))) return; //��ȷ��Ҫ���������˻���һ������
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","backStep","TaskNo="+taskNo+",UserID="+userID);
		alert(returnValue);
		return returnValue;
	},
	//�˻�
	backUp:function(taskNo){
		//�ݲ��������ˣ������Ż�����TBF99
		var flowState = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getTaskFlowState","TaskNo="+taskNo);
		if(flowState == "BACK"){
			alert("�����������˻����񣬲����ٴ��˻�");
			return;
		}
		var returnValue = AsControl.PopComp("/Common/FlowManage/FlowBackOpinionInfo.jsp","TaskNo="+taskNo+"&BackType=BACK","dialogWidth=1200px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		return returnValue;
	},
	//�˻ز�������
	backSupply:function(taskNo){
		var returnValue = AsControl.PopComp("/Common/FlowManage/FlowBackOpinionInfo.jsp","TaskNo="+taskNo+"&BackType=SUPPLY","dialogWidth=1200px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		return returnValue;
	},
	//��ȡ���������
	fetchTask:function(flowNo,phaseNo,userID){
		var taskMessage = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","fetchTask","FlowNo="+flowNo+",PhaseNo="+phaseNo+",UserID="+userID);
        if(taskMessage.length>0){
        	alert("��ȡ����ɹ�. ");
        }else{
        	alert("û�д���ȡ�����������! ");
        }
        return taskMessage;
	},
	//�˻������
	returnTaskToPool:function(taskNo){
		var taskMessage = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","returnTaskToPool","TaskNo="+taskNo);
		if(taskMessage == "SUCCESS"){
        	alert("�˻�����سɹ�");
        }else{
        	alert("�˻������ʧ��");
        }
		return taskMessage;
	},
	//���빤��̨
	applyPlatform:function(objectNo,objectType){
		//����Ƿ���Ҫ�鿴Ӱ������
		if(AsCredit.image_switch == "open"){
			var param = "FlowType=apply&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ViewID=001";
			AsCredit.openImageTab(param);
		}else{
			AsTaskView.flowApplytaskView(objectNo,objectType,"001");
		}
	},
	
	//��������̨
	approvePlatform:function(taskNo){
		var viewID = "002";
		if(this.checkIsApprovePhase(taskNo)){
			viewID = "001";
		}
		//��鵱ǰ�׶��Ƿ���Ҫ�鿴Ӱ������
		if(this.checkIsImageView(taskNo)&&AsCredit.image_switch == "open"){
			var param = "FlowType=approve&TaskNo="+taskNo+"&ViewID"+viewID;
			AsCredit.openImageTab(param);
		}else{
			AsTaskView.flowApprovetaskView(taskNo,viewID);
		}
	},
	//ɾ����¼
	delRecord:function(objectNo,objectType){
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","delRecord","ObjectNo="+objectNo+",ObjectType="+objectType);
		return returnValue;
	},
	getSelTaskNos:function(){
		var checkedRows = getCheckedRows(0);
		if(checkedRows.length < 1){
			//alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
		    return;
		}
		var taskNos = "",taskNo = "";
		for(var i=0;i<checkedRows.length;i++){
			taskNo = getItemValue(0,checkedRows[i],"SerialNo");
			taskNos += "@"+taskNo;	
		}
		taskNos = taskNos.substring(1);
		return taskNos;
	},
	//��ȡ��ǰ������ˮ��
	getCurPhaseAttr:function(taskNo){
		var curPhaseAttr = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","getCurPhaseAttr","TaskNo="+taskNo);
		return curPhaseAttr;
	},
	getNextBusinessInfo:function(objectNo,objectType){
		var resultMessage = RunJavaMethod("com.amarsoft.app.als.credit.apply.action.ApplyManageAction","getNextBusinessInfo","ObjectNo="+objectNo+",ObjectType="+objectType);
		if(!resultMessage){
			alert("��һ�׶�ҵ����ϢΪ�գ�");
			return;
		}else{
			return resultMessage;
		}
	}
};

/**
 * ������ƽ̨TaskViewTab
 * ghShi
 * 2014/05/10
 */
var AsTaskView={
	/**
	 * ������ģʽ�������������ͬ�Ǽ�
	 * @param taskID-�����������-��code��TaskViewTab��
	 * @param objectNo-������
	 * @param objectType-��������
	 * @param viewNo-��ͼȨ��
	 */
	commontaskView:function(taskID,objectNo,objectType,viewID){
		var param = "TaskID="+taskID+"&ObjectType="+objectType+"&ObjectNo="+objectNo+"&ViewID="+viewID;
		OpenComp("TaskViewTab","/Common/TaskViewTab/CommonTaskViewTab.jsp", param, "_blank", "");	
	},
	
	/**
	 * ��������׶ε�������������������
	 * @param taskNo-����������ˮ��
	 * @param objectNo-������
	 * @param objectType-��������
	 * @param viewNo-��ͼȨ��
	 */
	flowApplytaskView:function(objectNo,objectType,viewID){
		var param = "ObjectType="+objectType+"&ObjectNo="+objectNo+"&ViewID="+viewID;
		OpenComp("TaskViewTab","/Common/TaskViewTab/FlowApplyTaskViewTab.jsp", param, "_blank", "");	
	},
	
	/**
	 * ���������׶ε�������������������
	 * @param taskNo-����������ˮ��
	 * @param objectNo-������
	 * @param objectType-��������
	 * @param viewNo-��ͼȨ��
	 */
	flowApprovetaskView:function(taskNo,viewID){
		var param = "TaskNo="+taskNo+"&ViewID="+viewID;
		OpenComp("TaskViewTab","/Common/TaskViewTab/FlowApproveTaskViewTab.jsp", param, "_blank", "");	
	}
};


/**���鴦����ؽű� */
var AsNotice = {
	allotNotice:function(taskNos){
		var taskMessage = AsControl.PopComp("/Common/FlowManage/FlowNoticeFrame.jsp","TaskNos="+taskNos+"&SourceType=NEW","");
		if(taskMessage == "SUCCESS"){
			alert("�������֪ͨ���ͳɹ���");
		}
		reloadSelf();
	},
	gatherOpinion:function(taskNo){
		var returnMessage = AsControl.PopComp("/Common/FlowManage/FlowCollectOpinionFrame.jsp","TaskNo="+taskNo,"");
		if(!returnMessage || returnMessage=="_CANCEL_" ) return;
		return returnMessage;
	},
	addNoticeList:function(taskNos){
		var taskMessage = AsControl.PopComp("/Common/FlowManage/FlowNoticeFrame.jsp","TaskNos="+taskNos+"&SourceType=ADD","");
		if(taskMessage == "SUCCESS"){
			alert("�������֪ͨ���ͳɹ���");
		}
		reloadSelf();
	},
	delNoticeList:function(taskNo){
		alert("�˻���һ���ҽ����������������ΪʧЧ");
	}
};

/**
 * ��ʽ������
 */
var AsReport={
	getCurDocID:function(objectNo,objectType){
		var docID = RunJavaMethod("com.amarsoft.app.als.report.action.GetReportAction","getReportDocID","ObjectNo="+objectNo+",ObjectType="+objectType);
		return docID;		
	},
	isExistFile:function(objectNo,objectType){
		var flag = RunJavaMethod("com.amarsoft.app.als.report.action.GetReportAction","isExistFile","ObjectNo="+objectNo+",ObjectType="+objectType);
		if(flag == "FALSE"){
			return false;
		}else{
			return true;
		}
	},
	viewReport:function(objectNo,objectType){
		var docID = this.getCurDocID(objectNo, objectType);
		if (!docID){
			alert(getBusinessMessage('505'));//��ְ���鱨�滹δ��д��������д��ְ���鱨���ٲ鿴��
			return;
		}
		if(!this.isExistFile(objectNo,objectType)){
			alert("��ְ���鱨�滹δ���ɣ��������ɾ�ְ���鱨���ٲ鿴��");
			return;
		}
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle);
	}
};

/**
 * ǩ��������JS�ļ�
 */
var AsOpinion = {
	//�鿴���
	viewOpinions:function(taskNo){
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","TaskNo="+taskNo,"");
	},
	//ǩ�����
	signOpinion:function(taskNo){
		var curFlowState = AsTask.getCurFlowState(taskNo); 
		var compURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		if(curFlowState == "MEETING"){//����ͶƱ
			compURL = "/Common/FlowManage/SignVoteOpinionInfo.jsp";
		}
		var returnMessage = AsControl.PopComp(compURL,"TaskNo="+taskNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		return returnMessage;
	}
}; 
 