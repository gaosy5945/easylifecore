/**
 * 流程相关的js文件,包括类流程对象的管理，
 * AsTask 一般任务处理
 * AsNotic  通知处理
 * AsTaskView 任务处理
 * AsReport  格式化报告
 * AsOpinion 签署意见相关JS 处理方法
 * @author cjyu 
 */

/**
 * 流程对象
 * 包括了流程的提交，退回等常用操作
 */
var AsTask={
	/**获取当前任务流水号*/
	getInitTaskNo:function(objectNo,objectType){
		var taskNo = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getInitTaskNo","ObjectNo="+objectNo+",ObjectType="+objectType);
		if(!taskNo) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		} 
		return taskNo;
	},
	//获取当前任务流水号
	getCurTaskNo:function(objectNo,objectType,userID){
		var taskNo = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getUnFinishedTaskNo","ObjectNo="+objectNo+",ObjectType="+objectType+",UserID="+userID);
		if(!taskNo) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		} 
		return taskNo;
	},
	//获取当前任务状态
	getCurFlowState:function(taskNo){
		var curFlowState = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getTaskFlowState","TaskNo="+taskNo);
		return curFlowState;
	},
	//检查是否已经提交
	checkIsSubmit:function(taskNo) {
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsSubmit","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//判断当前阶段是否需要签署意见
	checkIsSign:function(taskNo) {
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsSign","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//判断当前阶段是否指定提交阶段
	checkIsAssigned:function(taskNo) {
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsAssigned","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//检查是否需要影像资料
	checkIsImageView:function(taskNo) {
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsImageView","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//检查是否签署意见
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
	//判断是否批复登记阶段
	checkIsApprovePhase:function(taskNo){
		var returnValue = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","checkIsApprovePhase","TaskNo="+taskNo);
		if(returnValue == "true"){
			return true;
		}else{
			return false;
		}
	},
	//查看流程图
	viewFlowGraph:function(taskNo){
		 AsControl.PopView("/Frame/ShowFlowInst.jsp","TaskNo="+taskNo,"dialogWidth=800px;dialogHeight=600px");
	},	
	//任务提交
	doTaskSubmit:function(taskNo){
		if(this.checkIsSubmit(taskNo)){
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			return "Working";
		}
		var curFlowState = this.getCurFlowState(taskNo); 
		if(curFlowState == "SUPPLY"){//补充资料
			var phaseOpinion = "补充完全";
			var phaseAction = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","getToSupplyUserID","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion);
			if(!phaseAction){
				alert("补充资料提交用户为空");
				return;
			}
			return this.doSupplyTask(taskNo,phaseAction,phaseOpinion);
		}else if(curFlowState == "MEETING"){
			return this.doVoteTask(taskNo,"NOTICEVOTE");
		}
		//弹出审批提交选择窗口/Common/WorkFlow/SubmitDialogNew.jsp		
		var returnValue = AsControl.PopComp("/Common/FlowManage/FlowSubmitDialog.jsp","TaskNo="+taskNo,"dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//A3Web提交页面逻辑
		//var returnValue = AsControl.PopComp("/Common/WorkFlow/SubmitDialogNew.jsp","TaskNo="+taskNo,"dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(!returnValue || returnValue == "_CANCEL_") return returnValue;
		else if (returnValue == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
		}else if (returnValue == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
		}else if(returnValue == "Working"){
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
		}
		return returnValue;
	},
	//任务提交
	doSubmit:function(objectNo,objectType,userID){
		var taskNo = this.getCurTaskNo(objectNo,objectType,userID);
		if(this.checkIsSubmit(taskNo)){
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}else{
			var curFlowState = this.getCurFlowState(taskNo); 
			if(curFlowState == "SUPPLY"){//补充资料
				var phaseOpinion = "补充完全";
				var phaseAction = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","getToSupplyUserID","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion);
				if(!phaseAction){
					alert("补充资料提交用户为空");
					return;
				}
				return this.doSupplyTask(taskNo,phaseAction,phaseOpinion);
			}else if(curFlowState == "MEETING"){
				return this.doVoteTask(taskNo,"NOTICEVOTE");
			}
			return this.doTaskSubmit(taskNo);
		}
	},
	//指定提交方法逻辑添加
	doAssignedTask:function(taskNo){
		//判断是否是指定提交阶段
		if(this.checkIsAssigned(taskNo)){
			var assignedTaskInfo = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getAssignedTaskInfo","TaskNo="+taskNo);
			if(!assignedTaskInfo && assignedTaskInfo != "@@"){
				var assignedTaskNo = assignedTaskInfo.split("@")[0];
				var assignedTaskPhaseInfo = assignedTaskInfo.split("@")[1];
				var nextAssignedTaskNo = assignedTaskInfo.split("@")[2];
				if(!confirm("该笔业务已经指定提交阶段。"+assignedTaskPhaseInfo+"\r\n你确定提交吗？")) return;
				var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","commitTask","TaskNo="+taskNo);
				if (returnValue == "Success"){
					alert(getHtmlMessage('18'));//提交成功！
				}else if (returnValue == "Failure"){
					alert(getHtmlMessage('9'));//提交失败！
				}else if(returnValue == "Working"){
					alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
				}
				return returnValue;
			}
		}
	},
	doSupplyTask:function(taskNo,phaseAction,phaseOpinion){
		if(!confirm("该笔业务确认补充完全提交吗？")) return; 
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","commitTask","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion+",PhaseAction="+phaseAction);
		return returnValue;
	},
	doVoteTask:function(taskNo,phaseAction){
		if(!confirm("该笔业务确认完成投票吗？")) return; 
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","finishVoteTask","TaskNo="+taskNo+",PhaseAction="+phaseAction);
		return returnValue;
	},
	//初始化阶段收回
	takeBackToInit:function(objectNo,objectType,userID){
		if(!confirm(getBusinessMessage('498'))) return; //确认收回该笔业务吗？
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","takeBackToInit","ObjectNo="+objectNo+",ObjectType="+objectType+",UserID="+userID);
		//收回成功后才刷新页面
		alert(returnValue);
		return returnValue;
	},
	//审批阶段收回
	takeBackToCur:function(taskNo,userID){
		if(!confirm(getBusinessMessage('498'))) return; //确认收回该笔业务吗？
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","takeBackToCur","TaskNo="+taskNo+",UserID="+userID);
		alert(returnValue);
		return returnValue;
	},
	//退回上一步
	backStep:function(taskNo,userID){
		//暂不允许连退，后续优化处理TBF99
		var flowState = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getTaskFlowState","TaskNo="+taskNo);
		if(flowState == "BACK"){
			alert("该任务属于退回任务，不能再次退回");
			return;
		}
		if(!confirm(getBusinessMessage('509'))) return; //您确认要将该申请退回上一环节吗？
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","backStep","TaskNo="+taskNo+",UserID="+userID);
		alert(returnValue);
		return returnValue;
	},
	//退回
	backUp:function(taskNo){
		//暂不允许连退，后续优化处理TBF99
		var flowState = RunJavaMethod("com.amarsoft.app.als.workflow.action.FlowManageAction","getTaskFlowState","TaskNo="+taskNo);
		if(flowState == "BACK"){
			alert("该任务属于退回任务，不能再次退回");
			return;
		}
		var returnValue = AsControl.PopComp("/Common/FlowManage/FlowBackOpinionInfo.jsp","TaskNo="+taskNo+"&BackType=BACK","dialogWidth=1200px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		return returnValue;
	},
	//退回补充资料
	backSupply:function(taskNo){
		var returnValue = AsControl.PopComp("/Common/FlowManage/FlowBackOpinionInfo.jsp","TaskNo="+taskNo+"&BackType=SUPPLY","dialogWidth=1200px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		return returnValue;
	},
	//获取任务池任务
	fetchTask:function(flowNo,phaseNo,userID){
		var taskMessage = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","fetchTask","FlowNo="+flowNo+",PhaseNo="+phaseNo+",UserID="+userID);
        if(taskMessage.length>0){
        	alert("获取任务成功. ");
        }else{
        	alert("没有待获取的任务池任务! ");
        }
        return taskMessage;
	},
	//退回任务池
	returnTaskToPool:function(taskNo){
		var taskMessage = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","returnTaskToPool","TaskNo="+taskNo);
		if(taskMessage == "SUCCESS"){
        	alert("退回任务池成功");
        }else{
        	alert("退回任务池失败");
        }
		return taskMessage;
	},
	//申请工作台
	applyPlatform:function(objectNo,objectType){
		//检查是否需要查看影像资料
		if(AsCredit.image_switch == "open"){
			var param = "FlowType=apply&ObjectNo="+objectNo+"&ObjectType="+objectType+"&ViewID=001";
			AsCredit.openImageTab(param);
		}else{
			AsTaskView.flowApplytaskView(objectNo,objectType,"001");
		}
	},
	
	//审批工作台
	approvePlatform:function(taskNo){
		var viewID = "002";
		if(this.checkIsApprovePhase(taskNo)){
			viewID = "001";
		}
		//检查当前阶段是否需要查看影像资料
		if(this.checkIsImageView(taskNo)&&AsCredit.image_switch == "open"){
			var param = "FlowType=approve&TaskNo="+taskNo+"&ViewID"+viewID;
			AsCredit.openImageTab(param);
		}else{
			AsTaskView.flowApprovetaskView(taskNo,viewID);
		}
	},
	//删除记录
	delRecord:function(objectNo,objectType){
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","delRecord","ObjectNo="+objectNo+",ObjectType="+objectType);
		return returnValue;
	},
	getSelTaskNos:function(){
		var checkedRows = getCheckedRows(0);
		if(checkedRows.length < 1){
			//alert(getHtmlMessage('1'));//请选择一条信息！ 
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
	//获取当前任务流水号
	getCurPhaseAttr:function(taskNo){
		var curPhaseAttr = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","getCurPhaseAttr","TaskNo="+taskNo);
		return curPhaseAttr;
	},
	getNextBusinessInfo:function(objectNo,objectType){
		var resultMessage = RunJavaMethod("com.amarsoft.app.als.credit.apply.action.ApplyManageAction","getNextBusinessInfo","ObjectNo="+objectNo+",ObjectType="+objectType);
		if(!resultMessage){
			alert("下一阶段业务信息为空！");
			return;
		}else{
			return resultMessage;
		}
	}
};

/**
 * 任务处理平台TaskViewTab
 * ghShi
 * 2014/05/10
 */
var AsTaskView={
	/**
	 * 非流程模式的任务处理，例如合同登记
	 * @param taskID-定义的任务编号-【code：TaskViewTab】
	 * @param objectNo-对象编号
	 * @param objectType-对象类型
	 * @param viewNo-视图权限
	 */
	commontaskView:function(taskID,objectNo,objectType,viewID){
		var param = "TaskID="+taskID+"&ObjectType="+objectType+"&ObjectNo="+objectNo+"&ViewID="+viewID;
		OpenComp("TaskViewTab","/Common/TaskViewTab/CommonTaskViewTab.jsp", param, "_blank", "");	
	},
	
	/**
	 * 流程申请阶段的任务处理，例如授信申请
	 * @param taskNo-流程任务流水号
	 * @param objectNo-对象编号
	 * @param objectType-对象类型
	 * @param viewNo-视图权限
	 */
	flowApplytaskView:function(objectNo,objectType,viewID){
		var param = "ObjectType="+objectType+"&ObjectNo="+objectNo+"&ViewID="+viewID;
		OpenComp("TaskViewTab","/Common/TaskViewTab/FlowApplyTaskViewTab.jsp", param, "_blank", "");	
	},
	
	/**
	 * 流程批复阶段的任务处理，例如审批管理
	 * @param taskNo-流程任务流水号
	 * @param objectNo-对象编号
	 * @param objectType-对象类型
	 * @param viewNo-视图权限
	 */
	flowApprovetaskView:function(taskNo,viewID){
		var param = "TaskNo="+taskNo+"&ViewID="+viewID;
		OpenComp("TaskViewTab","/Common/TaskViewTab/FlowApproveTaskViewTab.jsp", param, "_blank", "");	
	}
};


/**会议处理相关脚本 */
var AsNotice = {
	allotNotice:function(taskNos){
		var taskMessage = AsControl.PopComp("/Common/FlowManage/FlowNoticeFrame.jsp","TaskNos="+taskNos+"&SourceType=NEW","");
		if(taskMessage == "SUCCESS"){
			alert("贷审会议通知发送成功！");
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
			alert("贷审会议通知发送成功！");
		}
		reloadSelf();
	},
	delNoticeList:function(taskNo){
		alert("退回上一步且将关联会议的任务置为失效");
	}
};

/**
 * 格式化报告
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
			alert(getBusinessMessage('505'));//尽职调查报告还未填写，请先填写尽职调查报告再查看！
			return;
		}
		if(!this.isExistFile(objectNo,objectType)){
			alert("尽职调查报告还未生成，请先生成尽职调查报告再查看！");
			return;
		}
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle);
	}
};

/**
 * 签署意见相关JS文件
 */
var AsOpinion = {
	//查看意见
	viewOpinions:function(taskNo){
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","TaskNo="+taskNo,"");
	},
	//签署意见
	signOpinion:function(taskNo){
		var curFlowState = AsTask.getCurFlowState(taskNo); 
		var compURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		if(curFlowState == "MEETING"){//会议投票
			compURL = "/Common/FlowManage/SignVoteOpinionInfo.jsp";
		}
		var returnMessage = AsControl.PopComp(compURL,"TaskNo="+taskNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		return returnMessage;
	}
}; 
 