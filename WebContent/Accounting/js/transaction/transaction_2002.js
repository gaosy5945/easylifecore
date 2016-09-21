var aheadPaymentCalcFlag = true;//�����Ƿ���Ҫ������ǰ�������
var aheadPaymentScheFlag = false;//�����Ƿ���Ҫ������л���ƻ�����
/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var prePayAmt = getItemValue(0,getRow(),"PrePayAmt");
	var PrePayType = getItemValue(0,getRow(),"PrePayType");
	if(parseFloat(prePayAmt)<=0 && PrePayType != "3"){//����ȫ����ǰ����
		alert("�����ܽ���С�ڵ���0");
		setItemValue(0,getRow(),"PrePayAmt",0);
		return false;
	}
	
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	if(aheadPaymentCalcFlag)
	{
		var apcs=popComp("AheadPaymentConsult","/Accounting/Transaction/AheadPaymentConsult.jsp","TransactionSerialNo="+transactionSerialNo,"dialogWidth=50;dialogHeight=30;");
		if(typeof(apcs) != "undefined" && apcs.length != 0)
		{
			var prePayPrincipalAmt = apcs.split("@")[1];
			var prePayInterestAmt = apcs.split("@")[2];
			var SuspenseAmt = apcs.split("@")[3];
			setItemValue(0,0,"PrePayPrincipalAmt",prePayPrincipalAmt);
			setItemValue(0,0,"PrePayInterestAmt",prePayInterestAmt);
		}
	}
	
	if(aheadPaymentScheFlag)
	{
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","ToInheritObj=y&TransSerialNo="+transactionSerialNo,"");
		aheadPaymentScheFlag = false;
	}
	changePrepayType();
}

/*~[Describe=������ǰ������ѯ;InputParam=�����¼�;OutPutParam=��;]~*/
function repayConsult(){
	var prePayAmt = getItemValue(0,getRow(),"PrePayAmt");
	var transStatus = getItemValue(0,getRow(),"TransStatus");
	if(typeof(transStatus)=="undefined"||transStatus.length==0 || transStatus !="0"){
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
	setItemValue(0,getRow(),"INPUTUSERID",curUserID);
	setItemValue(0,getRow(),"INPUTUSERNAME",curUserName);
	setItemValue(0,getRow(),"INPUTORGID",curOrgID);
	setItemValue(0,getRow(),"INPUTORGNAME",curOrgName);
	setItemValue(0,getRow(),"INPUTDATE",businessDate);
	setItemValue(0,getRow(),"UPDATEUSERID",curUserID);
	setItemValue(0,getRow(),"UPDATEUSERNAME",curUserName);
	setItemValue(0,getRow(),"UPDATEORGID",curOrgID);
	setItemValue(0,getRow(),"UPDATEORGNAME",curOrgName);
	setItemValue(0,getRow(),"UPDATEDATE",businessDate);
	setValue("TransDate",businessDate);
	changePrepayType();
	changeCashOnlineFlag();
}

/*~[Describe=������ǰ���ʽ��ͬ�������¼�;InputParam=�����¼�;OutPutParam=��;]~*/
function changePrepayType(){
	var normalBalance = getItemValue(0,getRow(),"NormalBalance");
	var overdueBalance = getItemValue(0,getRow(),"OverdueBalance");
	var prePayType = getItemValue(0,0,"PrePayType");
	if(typeof(prePayType)=="undefined" || prePayType.length==0){
		return;
	}
	if(prePayType == "3"){
		setItemValue(0,0,"PrePayAmtFlag","1");
		setItemDisabled(0,0,"PrePayAmtFlag",true);
		setItemValue(0,0,"PrePayAmt",(parseFloat(normalBalance)+parseFloat(overdueBalance)));
		setItemDisabled(0,0,"PrePayAmt",true);
		setItemValue(0,0,"PrepayInterestBaseFlag","2");
		setItemDisabled(0,0,"PrepayInterestBaseFlag",true);
	}else{
		var sPrepayInterestDaysFlag = getItemValue(0,0,"PrepayInterestDaysFlag");
		if(typeof(sPrepayInterestDaysFlag)=="undefined" || sPrepayInterestDaysFlag.length==0){
			return;
		}
		setItemDisabled(0,0,"PrePayAmtFlag",false);
		setItemDisabled(0,0,"PrePayAmt",false);
		setItemDisabled(0,0,"PrepayInterestBaseFlag",false);
		setItemDisabled(0,0,"PrepayInterestDaysFlag",false);
	}
	
}