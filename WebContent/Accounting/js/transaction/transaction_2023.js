/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	try{
		if(myiframe0.SchePart1.vI_all("myiframe0")){
			return myiframe0.SchePart1.saveRecord();}
		else
			return false;
	}catch(e){
		
	}
	return true;
}


/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	openFeeList();
	reloadSelf();
}

/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
function openFeeList(){
	var obj = $('#ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
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
	showScheduleElement();
}

function showScheduleElement() {
	var transSerialNo = getItemValue(0,getRow(),"TransSerialNo");	
	var loanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");	
	var scheElement = getItemValue(0,getRow(),"ScheElement");
	OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/ScheduleElementView.jsp","LoanSerialNo="+loanSerialNo+"&TransSerialNo="+transSerialNo+"&ScheElement="+scheElement,"SchePart1","");
	
}