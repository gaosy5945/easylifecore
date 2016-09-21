   /*~[Describe=申请详情;InputParam=无;OutPutParam=无;]~*/
    function viewTab()
    {
    	var serialNo = getItemValue(0,getRow(0),"ObjectNo");
    	var customerID = getItemValue(0,getRow(0),"CustomerID");
    	var ProjectType = getItemValue(0,getRow(0),"ProjectType");
    	 if (typeof(serialNo)=="undefined" || serialNo.length==0){
             alert(getHtmlMessage('1'));//请选择一条信息！
             return;
         }
    	//打开详情页面
    	AsCredit.openFunction("ProjectApplyView","CustomerID="+customerID+"&SerialNo="+serialNo+"&ProjectType="+ProjectType+"&RightType=ReadOnly","");
    	reloadSelf();  
    }   
    
    /*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
    function viewOpinions() 
    {
        //获得申请类型、申请流水号、流程编号、阶段编号
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
        {
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        popComp("","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
    }
    /*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
    function signOpinion()
    {
        //获得申请类型、申请流水号、流程编号、阶段编号
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
        {
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }

        //获取任务流水号
        //sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
        sTaskNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
            alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
            return;
        }
        
        sCompID = "";
        sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
     	var returnValue =  popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&PhaseNo="+sPhaseNo,"dialogWidth=50;dialogHeight=37;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
     	if(returnValue=="success") doSubmit();//返回值为“success”，则弹出提交页面
    }
    
    /*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
    function doSubmit()
    {
        //获得申请类型、申请流水号、阶段编号
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        
        //获得任务流水号
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
        {
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        
        //检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
        sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
        if((typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) && sEndTime != "Null") {
            alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
            reloadSelf();
            return;
        }

        //检查是否签署意见
        sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
        if(typeof(sReturn)=="undefined" || sReturn.length==0) {
            alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
            return;
        }

        //弹出审批提交选择窗口
        sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//提交成功！
            //刷新件数及页面
            OpenComp("ApproveMain","/Common/WorkFlow/PartnerProjectFlow/ApproveMain.jsp","ComponentName=合作项目审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
        }else if (sPhaseInfo == "Failure"){
            alert(getHtmlMessage('9'));//提交失败！
            return;
        }else{
            sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
            //如果提交成功，则刷新页面
            if (sPhaseInfo == "Success"){
                alert(getHtmlMessage('18'));//提交成功！
                //刷新件数及页面
                OpenComp("ApproveMain","./ApproveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
            }else if (sPhaseInfo == "Failure"){
                alert(getHtmlMessage('9'));//提交失败！
                return;
            }
        }
    }