
var TransactionApply={
		
};
var tempTransCode = "";

/**
 * ������������
 */
function createTask(){
	//��������Ϊ��ͷ��β����,��
	var sTransactionFilter = ","+AsCredit.parameter["TransactionFilter"]+",";
	
	
	if(sTransactionFilter.indexOf(",") < 0 && sTransactionFilter.trim().length() > 0 && !sTransactionFilter.trim().toUpperCase().equals("ALL")){
		var transactionCode = sTransactionFilter;
		//var transObjectSelector = RunJavaMethod("com.amarsoft.app.accounting.config.loader.TransactionConfig","getTransactionDef","transactionCode="+transactionCode);
	    //���ʵ�֣���
	}else{
		//��sTransactionFilter�����еġ������滻Ϊ"@"
		var sLTransactionFilter = sTransactionFilter.replace(/,/g,"@");
		
		var paraString = "TransactionFilter,"+sLTransactionFilter+",UserID,"+AsCredit.userId;
		var returnValue = setObjectValue("SelectTransactionCode",paraString,"",0,0,"");
		if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
		{
			return;
		}
		
		returnValue = returnValue.split("@");
		var transactionCode = returnValue[0];
		tempTransCode = transactionCode;
	}
	var relativeObjectType = "";
	var relativeObjectNo = "";
	var transObjectSelector = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.GetColValue", "getColValue", "colName="+Attribute5+",tableName="+"CODE_LIBRARY,whereClause=String@CodeNo@T_Transaction_Def@String@ItemNo@"+transactionCode);
 
	if(typeof(transObjectSelector) == "undefined" || transObjectSelector.length == 0){
		relativeObjectType = "";
		relativeObjectNo = ""; 

		return;
	}
	else{		    

		try{
			var returnValue = eval(transObjectSelector.split("@")[1]);
			if(typeof(returnValue) == "undefined" || returnValue == "" || returnValue == "_CANCEL_" || returnValue == "_CLEAR_"){
				return;
			}
			relativeObjectType = returnValue.split("@")[0];
			relativeObjectNo = returnValue.split("@")[1];
		}
		catch(e){
			//alert("����{"+transactionCode+"}����Ķ���ѡ��������ʧ�ܣ�����Code_Library��Attribute5!");
			return;
		}
	}

	//modify begin add by zmxu 20120806 ���ƽ������뵫δִ�гɹ��ĸ��ֽ��ײ����ظ�����
	var allowApplyFlag = RunJavaMethodTrans("com.amarsoft.acct.accounting.web.GetAllowApplyFlag","getAllowApplyFlag","transactionCode="+transactionCode+
			",relativeObjectType="+relativeObjectType+",relativeObjectNo="+relativeObjectNo);
	if(allowApplyFlag != "true")
	{
		alert("��ҵ���Ѿ�����һ��δ��Ч�Ľ��׼�¼��������ͬʱ���룡");
		return;
	}
	//modify end
	var objectType=AsCredit.parameter["ApplyType"];

	var returnValue = RunJavaMethodTrans("com.amarsoft.acct.accounting.web.CreateTransaction","createTransaction","transactionCode="+transactionCode+
			",relativeObjectType="+relativeObjectType+",relativeObjectNo="+relativeObjectNo)+",transactionDate="+AsCredit.today+",userID"+AsCredit.userId;
 	if(returnValue.substring(0,5) != "true@") {
		alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
		return;
	}
	returnValue = returnValue.split("@");
	var transactionSerialNo = returnValue[1];
	if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
		alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
		return;
	}
	var sParamString = "ObjectType=Transaction"+"&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&ApplyType="+AsCredit.parameter["ApplyType"];
	AsCredit.openFunction("TransactionApplyDetail",sParamString);
	
/*	sCompID = "CreditTab";
	sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
	sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";

	OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);*/
	
	reloadSelf();	
	
}


/**
 * ������������
 */
function viewTask(){
	//����������͡�������ˮ��
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sTransCode = getItemValue(0,getRow(),"TransCode");
	var sApplyType = getItemValue(0,getRow(),"ApplyTYpe");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	
/*	sCompID = "CreditTab";
	sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
	sParamString = "ObjectType=Transaction&ObjectNo="+sObjectNo;
	OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	reloadSelf();*/
	
	var sParamString = "ObjectType=Transaction"+"&ObjectNo="+sObjectNo+"&TransCode="+sTransCode+"&ApplyType="+sApplyType;
	AsCredit.openFunction("TransactionApplyDetail",sParamString);
	//reloadSelf();	
}

/**
 * ȡ����������
 */
function cancelApply(){
	//����������͡�������ˮ��
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	if(confirm(getHtmlMessage('70'))){
		as_delete(0,'','delete');
		as_do(0,'','save');  //�������ɾ������Ҫ���ô����
	}   //!!���⣺�޷�ɾ����ACCT_TRANSACTION�еļ�¼
	reloadSelf();//����������ȡ��ʱ����
}

/**
 * ǩ�����
 */
function signOpinion(){
	//����������͡�������ˮ�š����̱�š��׶α��
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}

	//��ȡ������ˮ��
	var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+AsCredit.userId);
	if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
		alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
		return;
	}
	
	/*sCompID = "SignTaskOpinionInfo";
	sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
	popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");*/
	
	sStyle="dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
	AsCredit.openFunction("SignTaskOpinionInfo","TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,sStyle);
	reloadSelf();
}


/**
 *�ύ
 */
function doSubmit(){
	//��ȡ����sApplyType1��������
	//����������͡�������ˮ�š����̱�š��׶α�š���������
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sApplyType1 = AsCredit.parameter["ApplyType"];
	var sOccurType=getItemValue(0,getRow(),"OccurType");
	var sTransCode = getItemValue(0,getRow(),"TransCode");
	
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
	var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+AsCredit.userId);
	if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
		alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
		return;
	} 
	
	//���з�������̽��
	
/*	var sReturn = autoRiskScan("017","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ApplyType1="+sApplyType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo+"&TransCode="+sTransCode);
	if(sReturn != true){
		return;
	}*/

	//���������ύѡ�񴰿�		
	var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
	else if (sPhaseInfo == "Success"){
		alert(getHtmlMessage('18'));//�ύ�ɹ���
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


/**
 * �鿴���
 */
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

/*~[Describe=ѡ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
function selectTransObject(objectType,selectorname)//ѡ�����
{
	var s=setObjectValue(selectorname,"OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return objectType+"@"+serialNo;
}

function SelectFeeRecieve()//ѡ����ȡ����
{
	var sTransCode = tempTransCode;
	tempTransCode = "";
	
	var s = setObjectValue("SelectFeeRecieve","OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_FEE@"+serialNo;
}

function SelectFeePay()//ѡ��֧������
{
	var sTransCode = tempTransCode;
	tempTransCode = "";
	
	var s = setObjectValue("SelectFeePay","OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_FEE@"+serialNo;
}

function SelectWaiveFee()
{
	var s=setObjectValue("SelectWaiveFee","OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_FEE@"+serialNo;

}

function SelectRefundFee()
{
	var s=setObjectValue("SelectRefundFee","OrgID,"+AsCredit.orgId+",UserID,"+AsCredit.userId,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_FEE@"+serialNo;

}

function selectTransaction(TransCode)//ѡ��ԭ����
{
	alert(TransCode);
	var s=setObjectValue("SelectStrikeTransaction","OrgID,"+AsCredit.orgId+",TransCode,"+TransCode,"",0,0,"");
	if(typeof(s) == "undefined" || s == "" || s == "_CANCEL_" || s == "_CLEAR_")return;
	var serialNo = s.split('@')[0];
	return "jbo.acct.ACCT_TRANSACTION@"+serialNo;

}

/**
 * �ջ�
 */
function takeBack(){
	//���ջ��������ˮ��
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		return;
	}
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = RunMethod("WorkFlowEngine","GetInitPahseNo",sObjectType+","+sObjectNo);
	//��ȡ������ˮ��
	var sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
	if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0){
		if(confirm(getBusinessMessage('498'))){ //ȷ���ջظñ�ҵ����
			sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//�ջسɹ����ˢ��ҳ��
			if(sRetValue == "Commit"){
				reloadSelf();
			}
		}
	}else{
		alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
		return;
	}				
}


/**
 * ����������Ϣ
 */
function saveRecord(){
	if(!iV_all("0")) return;
	as_save("myiframe0");
/*	//if( !confirm("ȷ���������Ϣ��?")) return;
	alert(!beforeSave());
	if(!beforeSave()) return;  //����У�����
	  as_save("0","afterSave()");*/
}