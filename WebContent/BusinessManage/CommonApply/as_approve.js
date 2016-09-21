/**
*/
AsApprove={
		
};

AsApprove.openTask=function(){
	var objectType = getItemValue(0,getRow(),"ObjectType");
	var objectNo = getItemValue(0,getRow(),"ObjectNo");
	var taskNo = getItemValue(0,getRow(),"SerialNo");
	
	if (typeof(objectNo)=="undefined" || objectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	var sParamString = "ObjectType="+objectType+"&ObjectNo="+objectNo+"&TaskNo="+taskNo;
	AsCredit.openFunction("ApproveDetail",sParamString);
	reloadSelf();	
};


$(function(){
		var taskNo = AsCredit.getParameter("TaskNo");
		if(window.addButtonFront){
			if(typeof(taskNo)=="undefined") return ;
			var btn= AsControl.RunJspOne("/BusinessManage/CommonApply/LoadFlowButton.jsp?TaskNo="+taskNo);
			addButtonFront(btn);
		}
});


/*~[Describe=解析提交动作，生成按钮动作;InputParam=无;OutPutParam=无;]~*/
function doAction(phaseOpinion){
	var taskNo =  AsCredit.getParameter("TaskNo");
	var objectNo =  AsCredit.getParameter("objectNo");
	var objectType = AsCredit.getParameter("objectType");
	var viewID ="001";
	//自动风险探测
	if(viewID == "001" && objectType == "CreditApply"){
		//进行风险智能探测
		var riskMessage = autoRiskScan("001","ObjectType="+objectType+"&ObjectNo="+objectNo);
		if(riskMessage != true){
			return;
		} 
	}
	
	//申请阶段可以不用检查是否签署意见
	var opinionMessage = AsTask.checkIsOpinion(taskNo);
	if(!opinionMessage) {
		alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
		if(window.clickTab){
			clickTab("77");
		}else{
			signTaskOpinion();
		}
		//signTaskOpinion();
		return;
	}
	var returnMessage = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","getActionInfo","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion);
	var phaseAction = "";
	//没有后续事件，直接提交
	if(returnMessage.indexOf("CONTINUE")<0){
		//进行选择提交对象处理
		phaseAction = AsControl
				.PopComp("/Frame/page/tools/SelectDialog.jsp","SelectDialogUrl=/Common/FlowManage/FlowUserList.jsp&ActionList="+returnMessage,
						"dialogWidth=800px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (phaseAction == "_CLEAR_" || !phaseAction) return;
	}else{
		phaseAction = returnMessage.split(",")[2];
	}
	var nextPhaseInfo = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","getNextPhaseInfo","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion+",PhaseAction="+phaseAction);
	var promtMessage = "该笔业务的"+nextPhaseInfo+"\r\n你确定提交吗？";
	if(phaseAction){
		promtMessage = "该笔业务的"+nextPhaseInfo+"\r\n处理人是:"+phaseAction+",\r\n你确定提交吗？";
	}
	if (!confirm(promtMessage)) return;
	var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","commitTask","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion+",UserID=<%=userID%>,PhaseAction="+phaseAction);
	if (returnValue == "Success"){
		alert(getHtmlMessage('18'));//提交成功！
	}else if (returnValue == "Failure"){
		alert(getHtmlMessage('9'));//提交失败！
	}else if(returnValue == "Working"){
		alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
	}	
	top.close();
}

function backStep(taskNo){
	//检查是否签署意见
	var returnValue = AsTask.checkIsOpinion(taskNo);
	if(returnValue) {
		alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
		return;
	}
	returnValue = AsTask.backStep(taskNo,"<%=userID%>");
	if (returnValue){
		top.close();
	}
}


/*~[Describe=退回;InputParam=无;OutPutParam=无;]~*/
function backUp(taskNo){
	
	//var taskNo = getItemValue(0,getRow(),"SerialNo");
	if(!taskNo) {
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	//检查是否签署意见
	var opinionMessage = AsTask.checkIsOpinion(taskNo);
	if(opinionMessage) {
		alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
		return;
	}
	
	var taskMessage = AsTask.backUp(taskNo);
	if(!taskMessage || taskMessage == "_CANCEL_" ) return;
	else if(taskMessage == "SUCCESS"){
		alert("退回成功！");
	}
	 if(typeof(DZ)!="undefined" && DZ.length>0){//List页面
		 reloadSelf();//刷新
	 }else{
		 top.close();//弹出来的就关闭
	 }
	//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
}


/*~[Describe=自动风险探测;InputParam=无;OutPutParam=无;]~*/
function riskSkan(){
	//获得申请类型、申请流水号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		sObjectType=AsCredit.getParameter("ObjectType");
		sObjectNo=AsCredit.getParameter("ObjectNo");
	}
	
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){ 
		alert(getHtmlMessage('1'));//请选择一条信息！
		return ;
	}

	//进行风险智能探测
	autoRiskScan("001","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,20);
}

function finishApply(){
	var objectNo=AsCredit.getParameter("ObjectNo");
	var parameters="ObjectNo="+objectNo+"&ObjectType=CreditApply&NewObjectType=ApproveApply";
	alert(parameters);
	sReturn=AsCredit.runFunction("ApplyFinish",parameters);
	alert(sReturn.toString());
}