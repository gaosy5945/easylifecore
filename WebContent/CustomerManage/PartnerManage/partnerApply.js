 function cancelApply(){
		if(!confirm('确实要删除吗?')) return;
		var objectNo=getItemValue(0,getRow(),"SerialNo");
		var returnValue = AsTask.delRecord(objectNo,"PartnerProjectAppl");
		if(returnValue == "SUCCESS"){
			alert("删除成功！");
		}else{
			alert("删除失败！");
		}
		reloadSelf();
	};
	
function newApply(){
	var returnValue = setObjectValue("selectPartner","userid," + AsCredit.userId,"",0,0,"");
	if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == '_CANCEL_'){
		return;
	}
	returnValue = returnValue.split("@");
	var size = "dialogWidth=450px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
	param = "customerID="+returnValue[1]+"&partnerType="+returnValue[0];
	
	var serialno = AsControl.PopView("/CustomerManage/PartnerManage/NewProjectInfo.jsp", param, size );
	if(typeof(serialno) == "undefined" || serialno.length == 0 || serialno == '_CANCEL_'){
		return;
	}
	//打开详情页面
	AsCredit.openFunction("ProjectApplyView","CustomerID="+returnValue[1]+"&SerialNo="+serialno+"&ProjectType="+returnValue[0],"");
	reloadSelf();
}

/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
function viewTab(){
	var serialNo = getItemValue(0,getRow(0),"SerialNo");
	var customerID = getItemValue(0,getRow(0),"CustomerID");
	var ProjectType = getItemValue(0,getRow(0),"ProjectType");
    if (typeof(serialNo)=="undefined" || serialNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	//打开详情页面
	AsCredit.openFunction("ProjectApplyView","CustomerID="+customerID+"&SerialNo="+serialNo+"&ProjectType="+ProjectType,"");
	reloadSelf();
}


/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
function doSubmit(){
    //获得申请类型、申请流水号、流程编号、阶段编号、申请类型
    var sObjectType = getItemValue(0,getRow(),"ObjectType");
    var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    var sCRSerialNo = getItemValue(0,getRow(),"SerialNo");
    var sFlowNo = getItemValue(0,getRow(),"FlowNo");
    var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
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
    var sTaskNo = RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+AsCredit.userId);
    if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
        alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
        return;
    }
    
    //检查是否签署意见
    var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
    if(typeof(sReturn)=="undefined" || sReturn.length==0) {
        alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
        return;
    }
    
    //弹出审批提交选择窗口
    var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
	else if (sPhaseInfo == "Success"){
        alert(getHtmlMessage('18'));//提交成功！
        //更新finallyResult方法，此方法已经默认为把最新的人工认定结果赋值给finallyResult，如果有其他的更新逻辑，请自行更新类方法。
        RunMethod("WorkFlowEngine","UpdateClassifyManResult",sCRSerialNo + "," +sTaskNo);
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


/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
function signOpinion(){
    var sObjectType = getItemValue(0,getRow(),"ObjectType"); 
    var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    var sFlowNo = getItemValue(0,getRow(),"FlowNo");
    var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");       
    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
        alert(getHtmlMessage('1'));//请选择一条信息！
        return;
    }
    //获取Flow_Task表中的任务流水号
    var sTaskNo = RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+AsCredit.userId);
    if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
        alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
        return;
    }
    //签署意见
    var returnValue = PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignTaskOpinionInfo.jsp","TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo,"dialogWidth=600px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
 	if(returnValue=="success") doSubmit();//返回值为“success”，则弹出提交页面
}

/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
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