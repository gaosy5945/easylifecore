var aheadPaymentScheFlag = false;//�����Ƿ���Ҫ������л���ƻ�����
/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	
	var MaturityDate = getItemValue(0,getRow(),"MaturityDate");
	var OLDMaturityDate = getItemValue(0,getRow(),"OLDMaturityDate");
	//��չ��ʹ�ô˶δ���
	setItemValue(0,0,"TransDate",OLDMaturityDate);
	if(MaturityDate<=OLDMaturityDate)
	{
		alert("�µ����ձ������ԭ�����գ�");
		return false;
	}
	if(MaturityDate == OLDMaturityDate){
		alert("�����������ǰһ�£�������ѡ��");
		return false;
	}
	
	if(MaturityDate<=transDate)
	{
		alert("�����ձ��������Ч���ڣ�");
		return false;
	}
	//���ֶ�ָ�����������ʱ��ʹ����δ���
	try{
		myiframe0.RatePart.saveRecord();
	}catch(e){
		
	}
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){	
	if(aheadPaymentScheFlag)
	{
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","TransSerialNo="+transactionSerialNo,"");
		aheadPaymentScheFlag = false;
	}
	calcFINTermID();
	calcLoanRateTermID();
	openFeeList();
}

/*~[Describe=����ƻ�����;InputParam=��;OutPutParam=��;]~*/
function viewConsult(){
	aheadPaymentScheFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
function openFeeList(){
	var obj = $('#ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
}

/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
function calcLoanRateTermID(){
	var obj = $('#ContentFrame_RatePart');
	if(typeof(obj) == "undefined" || obj == null) return;
	var sLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
	if(typeof(sLoanRateTermID) == "undefined" || sLoanRateTermID.length == 0) return;
	var sPutoutDate = getItemValue(0,getRow(),"LoanPutOutDate");
	var sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
	if(typeof(sMaturityDate) == "undefined" || sMaturityDate.length == 0){ 
		sMaturityDate = getItemValue(0,getRow(),"OLDMaturityDate");
	}
	var  termMonth = RunMethod("BusinessManage","GetUpMonths",sPutoutDate+","+sMaturityDate);
	OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Status=0@1&termMonth="+termMonth+"&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RateSegmentView&TermObjectType=<%=BUSINESSOBJECT_CONSTANTS.loan_rate_segment%>&TermID="+sLoanRateTermID,"RatePart","");
}

/*~[Describe=��Ϣ��Ϣ;InputParam=��;OutPutParam=��;]~*/
function calcFINTermID(){
	var obj = $('#ContentFrame_FINPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("FinTermList","/Accounting/LoanDetail/LoanTerm/FinTermList.jsp","RightType=ReadOnly&Status=2&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","FINPart","");
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
	openFeeList();
	calcLoanRateTermID();
	calcFINTermID();
}
