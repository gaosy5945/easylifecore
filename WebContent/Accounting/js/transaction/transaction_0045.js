var aheadPaymentScheFlag = false;//�����Ƿ���Ҫ������л���ƻ�����
/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
		alert("�������뻹���˺�!");
		return false;
	}
	
	return true;
}

/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
function openFeeList(){
	var obj = $('#ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("TransactionFeeList","/Accounting/Transaction/TransactionFeeList.jsp","ToInheritObj=y&ParentTransSerialNo="+transactionSerialNo,"NEWFEEPart","");
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	
}

/*~[Describe=������ǰ������ѯ;InputParam=�����¼�;OutPutParam=��;]~*/
function repayConsult(){
	var sTransStatus = getItemValue(0,getRow(),"TransStatus");
	if(typeof(sTransStatus)=="undefined"||sTransStatus.length==0 || sTransStatus !="0"){
		alert("�˱ʽ���״̬���Ǵ��ύ,����������!");
		return;
	}
	aheadPaymentCalcFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=����ƻ�����;InputParam=��;OutPutParam=��;]~*/
function viewConsult(){
	aheadPaymentScheFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=��ʼ��;InputParam=��;OutPutParam=��;]~*/
function initRow(){
	if (getRowCount(0)==0) {
		as_add("myiframe0");//������¼
	}
/*	setItemValue(0,getRow(),"INPUTUSERID",curUserID);
	setItemValue(0,getRow(),"INPUTUSERNAME",curUserName);
	setItemValue(0,getRow(),"INPUTORGID",curOrgID);
	setItemValue(0,getRow(),"INPUTORGNAME",curOrgName);
	setItemValue(0,getRow(),"INPUTDATE",businessDate);
	setItemValue(0,getRow(),"UPDATEUSERID",curUserID);
	setItemValue(0,getRow(),"UPDATEUSERNAME",curUserName);
	setItemValue(0,getRow(),"UPDATEORGID",curOrgID);
	setItemValue(0,getRow(),"UPDATEORGNAME",curOrgName);
	setItemValue(0,getRow(),"UPDATEDATE",businessDate);*/
	setItemValue(0,getRow(),"PayPrincipalAmt",payPrincipalAmt);
	setItemValue(0,getRow(),"PayInteAmt",payInteAmt);
	setValue("TransDate",businessDate);
	setItemValue(0,getRow(),"PrepayInterestDaysFlag","02");
	openFeeList();
	changeCashOnlineFlag();
}
