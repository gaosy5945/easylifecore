/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
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


/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	openFeeList();
	reloadSelf();
}

/*~[Describe=费用信息;InputParam=无;OutPutParam=无;]~*/
function openFeeList(){
	var obj = $('#ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
}

/*~[Describe=初始化;InputParam=无;OutPutParam=无;]~*/
function initRow(){
	if (getRowCount(0)==0) {
		as_add("myiframe0");//新增记录
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