/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var WAIVEPRINCIPALAMT = getItemValue(0,getRow(),"WAIVEPRINCIPALAMT");
	var WAIVEINTEAMT = getItemValue(0,getRow(),"WAIVEINTEAMT");
	var WAIVECOMPDINTEAMT = getItemValue(0,getRow(),"WAIVECOMPDINTEAMT");
	var WAIVEFINEAMT = getItemValue(0,getRow(),"WAIVEFINEAMT");
	var WAIVEGRACEINTEAMT = getItemValue(0,getRow(),"WAIVEGRACEINTEAMT");
	var PAYPRINCIPALAMT = getItemValue(0,getRow(),"PAYPRINCIPALAMT");
	var PAYINTEAMT = getItemValue(0,getRow(),"PAYINTEAMT");
	var PAYCOMPDINTEAMT = getItemValue(0,getRow(),"PAYCOMPDINTEAMT");
	var PAYFINEAMT = getItemValue(0,getRow(),"PAYFINEAMT");
	var PAYGRACEINTEAMT = getItemValue(0,getRow(),"PAYGRACEINTEAMT");
	var ACTUALPAYPRINCIPALAMT = getItemValue(0,getRow(),"ACTUALPAYPRINCIPALAMT");
	var ACTUALPAYINTEAMT = getItemValue(0,getRow(),"ACTUALPAYINTEAMT");
	var ACTUALPAYCOMPDINTEAMT = getItemValue(0,getRow(),"ACTUALPAYCOMPDINTEAMT");
	var ACTUALPAYFINEAMT = getItemValue(0,getRow(),"ACTUALPAYFINEAMT");
	var ACTUALPAYGRACEINTEAMT = getItemValue(0,getRow(),"ACTUALPAYGRACEINTEAMT");
	var psSerialNo = getItemValue(0,getRow(),"PSSERIALNO");
	
	var LoanNormalBalance = getItemValue(0,getRow(),"LoanNormalBalance");
	var OverDueBalance = getItemValue(0,getRow(),"OverDueBalance");
	var OdInteBalance = getItemValue(0,getRow(),"OdInteBalance");
	var CompdInteBalance = getItemValue(0,getRow(),"CompdInteBalance");
	var Fineintebalance = getItemValue(0,getRow(),"Fineintebalance");
	if(typeof(psSerialNo) != "undefined" && psSerialNo != null && psSerialNo.length > 0) {
		if(WAIVEPRINCIPALAMT+PAYPRINCIPALAMT-ACTUALPAYPRINCIPALAMT < 0
		  || WAIVEINTEAMT+PAYINTEAMT-ACTUALPAYINTEAMT < 0
		  || WAIVECOMPDINTEAMT+PAYCOMPDINTEAMT-ACTUALPAYCOMPDINTEAMT < 0
		  || WAIVEFINEAMT+PAYFINEAMT-ACTUALPAYFINEAMT < 0
		  || WAIVEGRACEINTEAMT+PAYGRACEINTEAMT-ACTUALPAYGRACEINTEAMT < 0){
			alert("�������Ϊ����ʱ����С�ڶ�ӦӦ����");
			return false;
		}
	} else {
		if(WAIVEPRINCIPALAMT > LoanNormalBalance || WAIVEPRINCIPALAMT + OverDueBalance < 0
				|| WAIVEINTEAMT + OdInteBalance < 0
				|| WAIVECOMPDINTEAMT + CompdInteBalance < 0
				|| WAIVEFINEAMT + Fineintebalance < 0) {
			alert("����������Ч��Χ����������д��");
			return false;
		}
		if(WAIVEGRACEINTEAMT != 0) {
			alert("δѡ�񻹿�ƻ����벻Ҫ������������Ϣ��");
			return false;
		}
	}
	if(WAVEPRINCIPALAMT == 0 
		&& WAVEINTEAMT == 0 
		&& WAVECOMPDINTEAMT == 0 
		&& WAVEFINEAMT == 0
		&& WAVEGRACEINTEAMT == 0)
	{
		alert("��������ȫ��Ϊ�㣡");
		return false;
	}
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	
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
}

function selectPSS()
{
	var loanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");
	setObjectValue("SelectPaymentSchedule2","ObjectType,jbo.acct.ACCT_LOAN,ObjectNo,"+loanSerialNo+",Today,"+businessDate,"@PAYDATE@0@PAYPRINCIPALAMT@1@PAYINTEAMT@2@PAYCOMPDINTEAMT@3@PAYFINEAMT@4@PAYGRACEINTEAMT@5@ACTUALPAYPRINCIPALAMT@6@ACTUALPAYINTEAMT@7@ACTUALPAYCOMPDINTEAMT@8@ACTUALPAYFINEAMT@9@ACTUALPAYGRACEINTEAMT@10@PSSERIALNO@11",0,0,"");
}

