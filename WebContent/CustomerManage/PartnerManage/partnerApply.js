 function cancelApply(){
		if(!confirm('ȷʵҪɾ����?')) return;
		var objectNo=getItemValue(0,getRow(),"SerialNo");
		var returnValue = AsTask.delRecord(objectNo,"PartnerProjectAppl");
		if(returnValue == "SUCCESS"){
			alert("ɾ���ɹ���");
		}else{
			alert("ɾ��ʧ�ܣ�");
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
	//������ҳ��
	AsCredit.openFunction("ProjectApplyView","CustomerID="+returnValue[1]+"&SerialNo="+serialno+"&ProjectType="+returnValue[0],"");
	reloadSelf();
}

/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
function viewTab(){
	var serialNo = getItemValue(0,getRow(0),"SerialNo");
	var customerID = getItemValue(0,getRow(0),"CustomerID");
	var ProjectType = getItemValue(0,getRow(0),"ProjectType");
    if (typeof(serialNo)=="undefined" || serialNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	//������ҳ��
	AsCredit.openFunction("ProjectApplyView","CustomerID="+customerID+"&SerialNo="+serialNo+"&ProjectType="+ProjectType,"");
	reloadSelf();
}


/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
function doSubmit(){
    //����������͡�������ˮ�š����̱�š��׶α�š���������
    var sObjectType = getItemValue(0,getRow(),"ObjectType");
    var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    var sCRSerialNo = getItemValue(0,getRow(),"SerialNo");
    var sFlowNo = getItemValue(0,getRow(),"FlowNo");
    var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
        alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return;
    }
    
    //����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
    var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
    if(sNewPhaseNo != sPhaseNo) {
        alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
        reloadSelf();
        return;
    }

    //��ȡ������ˮ��
    var sTaskNo = RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+AsCredit.userId);
    if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
        alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
        return;
    }
    
    //����Ƿ�ǩ�����
    var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
    if(typeof(sReturn)=="undefined" || sReturn.length==0) {
        alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
        return;
    }
    
    //���������ύѡ�񴰿�
    var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
	else if (sPhaseInfo == "Success"){
        alert(getHtmlMessage('18'));//�ύ�ɹ���
        //����finallyResult�������˷����Ѿ�Ĭ��Ϊ�����µ��˹��϶������ֵ��finallyResult������������ĸ����߼��������и����෽����
        RunMethod("WorkFlowEngine","UpdateClassifyManResult",sCRSerialNo + "," +sTaskNo);
        reloadSelf();
    }else if (sPhaseInfo == "Failure"){
        alert(getHtmlMessage('9'));//�ύʧ�ܣ�
        return;
    }else{
        sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        //����ύ�ɹ�����ˢ��ҳ��
        if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//�ύ�ɹ���
            reloadSelf();
        }else if (sPhaseInfo == "Failure"){
            alert(getHtmlMessage('9'));//�ύʧ�ܣ�
            return;
        }
    }
}


/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
function signOpinion(){
    var sObjectType = getItemValue(0,getRow(),"ObjectType"); 
    var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    var sFlowNo = getItemValue(0,getRow(),"FlowNo");
    var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");       
    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
        alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return;
    }
    //��ȡFlow_Task���е�������ˮ��
    var sTaskNo = RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+AsCredit.userId);
    if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
        alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
        return;
    }
    //ǩ�����
    var returnValue = PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignTaskOpinionInfo.jsp","TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo,"dialogWidth=600px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
 	if(returnValue=="success") doSubmit();//����ֵΪ��success�����򵯳��ύҳ��
}

/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
function viewOpinions(){
    //����������͡�������ˮ�š����̱�š��׶α��
    var sObjectType = getItemValue(0,getRow(),"ObjectType");
    var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    var sFlowNo = getItemValue(0,getRow(),"FlowNo");
    var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
        alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        return;
    }
    popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
}