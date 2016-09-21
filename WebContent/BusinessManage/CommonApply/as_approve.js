/**
*/
AsApprove={
		
};

AsApprove.openTask=function(){
	var objectType = getItemValue(0,getRow(),"ObjectType");
	var objectNo = getItemValue(0,getRow(),"ObjectNo");
	var taskNo = getItemValue(0,getRow(),"SerialNo");
	
	if (typeof(objectNo)=="undefined" || objectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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


/*~[Describe=�����ύ���������ɰ�ť����;InputParam=��;OutPutParam=��;]~*/
function doAction(phaseOpinion){
	var taskNo =  AsCredit.getParameter("TaskNo");
	var objectNo =  AsCredit.getParameter("objectNo");
	var objectType = AsCredit.getParameter("objectType");
	var viewID ="001";
	//�Զ�����̽��
	if(viewID == "001" && objectType == "CreditApply"){
		//���з�������̽��
		var riskMessage = autoRiskScan("001","ObjectType="+objectType+"&ObjectNo="+objectNo);
		if(riskMessage != true){
			return;
		} 
	}
	
	//����׶ο��Բ��ü���Ƿ�ǩ�����
	var opinionMessage = AsTask.checkIsOpinion(taskNo);
	if(!opinionMessage) {
		alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
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
	//û�к����¼���ֱ���ύ
	if(returnMessage.indexOf("CONTINUE")<0){
		//����ѡ���ύ������
		phaseAction = AsControl
				.PopComp("/Frame/page/tools/SelectDialog.jsp","SelectDialogUrl=/Common/FlowManage/FlowUserList.jsp&ActionList="+returnMessage,
						"dialogWidth=800px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (phaseAction == "_CLEAR_" || !phaseAction) return;
	}else{
		phaseAction = returnMessage.split(",")[2];
	}
	var nextPhaseInfo = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","getNextPhaseInfo","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion+",PhaseAction="+phaseAction);
	var promtMessage = "�ñ�ҵ���"+nextPhaseInfo+"\r\n��ȷ���ύ��";
	if(phaseAction){
		promtMessage = "�ñ�ҵ���"+nextPhaseInfo+"\r\n��������:"+phaseAction+",\r\n��ȷ���ύ��";
	}
	if (!confirm(promtMessage)) return;
	var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.workflow.action.FlowManageAction","commitTask","TaskNo="+taskNo+",PhaseOpinion="+phaseOpinion+",UserID=<%=userID%>,PhaseAction="+phaseAction);
	if (returnValue == "Success"){
		alert(getHtmlMessage('18'));//�ύ�ɹ���
	}else if (returnValue == "Failure"){
		alert(getHtmlMessage('9'));//�ύʧ�ܣ�
	}else if(returnValue == "Working"){
		alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
	}	
	top.close();
}

function backStep(taskNo){
	//����Ƿ�ǩ�����
	var returnValue = AsTask.checkIsOpinion(taskNo);
	if(returnValue) {
		alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
		return;
	}
	returnValue = AsTask.backStep(taskNo,"<%=userID%>");
	if (returnValue){
		top.close();
	}
}


/*~[Describe=�˻�;InputParam=��;OutPutParam=��;]~*/
function backUp(taskNo){
	
	//var taskNo = getItemValue(0,getRow(),"SerialNo");
	if(!taskNo) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	//����Ƿ�ǩ�����
	var opinionMessage = AsTask.checkIsOpinion(taskNo);
	if(opinionMessage) {
		alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
		return;
	}
	
	var taskMessage = AsTask.backUp(taskNo);
	if(!taskMessage || taskMessage == "_CANCEL_" ) return;
	else if(taskMessage == "SUCCESS"){
		alert("�˻سɹ���");
	}
	 if(typeof(DZ)!="undefined" && DZ.length>0){//Listҳ��
		 reloadSelf();//ˢ��
	 }else{
		 top.close();//�������ľ͹ر�
	 }
	//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
}


/*~[Describe=�Զ�����̽��;InputParam=��;OutPutParam=��;]~*/
function riskSkan(){
	//����������͡�������ˮ��
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		sObjectType=AsCredit.getParameter("ObjectType");
		sObjectNo=AsCredit.getParameter("ObjectNo");
	}
	
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){ 
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return ;
	}

	//���з�������̽��
	autoRiskScan("001","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,20);
}

function finishApply(){
	var objectNo=AsCredit.getParameter("ObjectNo");
	var parameters="ObjectNo="+objectNo+"&ObjectType=CreditApply&NewObjectType=ApproveApply";
	alert(parameters);
	sReturn=AsCredit.runFunction("ApplyFinish",parameters);
	alert(sReturn.toString());
}