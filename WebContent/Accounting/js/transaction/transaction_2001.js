var nLessZ = "����С�ڵ���0";
var MoreZ = "�������0";
/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var actualPayAmt = getItemValue(0,getRow(),"ActualPayAmt");
	if(actualPayAmt<=0){
		alert("�����ܽ��"+nLessZ);
		setItemValue(0,getRow(),"ActualPayAmt",0);
		return false;
	}
	//У���˺ű���
	var payAccountNo = getItemValue(0,getRow(),"PayAccountNo");
	if(typeof(payAccountNo)=="undefined"||payAccountNo.length==0){
		alert("�������뻹���˺�!");
		return false;
	}
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	
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
	afterSave();
	changeCashOnlineFlag();
}

/*~[Describe=���㻹���ܽ��;InputParam=�����¼�;OutPutParam=��;]~*/
function changeActualPayAmt(){
	var OverdueBalance = getItemValue(0,getRow(),"OverdueBalance");//�ڹ�Ƿ�����
	var InterestBalance = getItemValue(0,getRow(),"InterestBalance");//�ڹ�ǷϢ���
	var PrincipalPenaltyBalance = getItemValue(0,getRow(),"PrincipalPenaltyBalance");//���ڷ�Ϣ���
	var InterestPenaltyBalance = getItemValue(0,getRow(),"InterestPenaltyBalance");//���ڸ�Ϣ���
	
	var ActualPayPrincipalAmt = getItemValue(0,getRow(),"ActualPayPrincipalAmt");//ʵ�ձ���
	var ActualPayInterestAmt = getItemValue(0,getRow(),"ActualPayInterestAmt");//ʵ����Ϣ
	var ActualPayPrincipalPenaltyAmt = getItemValue(0,getRow(),"ActualPayPrincipalPenaltyAmt");//ʵ�շ�Ϣ
	var ActualPayInterestPenaltyAmt = getItemValue(0,getRow(),"ActualPayInterestPenaltyAmt");//ʵ�ո�Ϣ
	
	var temp = "���ܳ���";
	if(parseFloat(ActualPayPrincipalAmt)>parseFloat(OverdueBalance)){
		alert("ʵ�ձ���"+temp+"Ƿ������");
		setItemValue(0,getRow(),"ActualPayPrincipalAmt",0);
		return;
	}
	if(parseFloat(ActualPayInterestAmt)>parseFloat(InterestBalance)){
		alert("ʵ����Ϣ"+temp+"Ƿ����Ϣ");
		setItemValue(0,getRow(),"ActualPayInterestAmt",0);
		return;
	}
	if(parseFloat(ActualPayPrincipalPenaltyAmt)>parseFloat(PrincipalPenaltyBalance)){
		alert("ʵ�շ�Ϣ"+temp+"���ڷ�Ϣ���");
		setItemValue(0,getRow(),"ActualPayPrincipalPenaltyAmt",0);
		return;
	}
	if(parseFloat(ActualPayInterestPenaltyAmt)>parseFloat(InterestPenaltyBalance)){
		alert("ʵ�ո�Ϣ"+temp+"���ڸ�Ϣ���");
		setItemValue(0,getRow(),"ActualPayInterestPenaltyAmt",0);
		return;
	}
	
	if(parseFloat(ActualPayPrincipalAmt)<0){
		alert("ʵ�ձ���"+nLessZ);
		setItemValue(0,getRow(),"ActualPayPrincipalAmt",0);
		return;
	}
	if(parseFloat(ActualPayInterestAmt)<0){
		alert("ʵ����Ϣ"+nLessZ);
		setItemValue(0,getRow(),"ActualPayInterestAmt",0);
		return;
	}
	if(parseFloat(ActualPayPrincipalPenaltyAmt)<0){
		alert("ʵ�շ�Ϣ"+nLessZ);
		setItemValue(0,getRow(),"ActualPayPrincipalPenaltyAmt",0);
		return;
	}
	if(parseFloat(ActualPayInterestPenaltyAmt)<0){
		alert("ʵ�ո�Ϣ"+nLessZ);
		setItemValue(0,getRow(),"ActualPayInterestPenaltyAmt",0);
		return;
	}
	
	setItemValue(0,getRow(),"ActualPayAmt",(parseFloat(ActualPayPrincipalAmt)+parseFloat(ActualPayInterestAmt)+parseFloat(ActualPayPrincipalPenaltyAmt)+parseFloat(ActualPayInterestPenaltyAmt)).toFixed(2));
}