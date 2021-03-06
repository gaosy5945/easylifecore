var aheadPaymentScheFlag = false;//控制是否需要贷款进行还款计划测算
/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	try{
		myiframe0.NEWRatePart.saveRecord();
	}catch(e){
		
	}
	
	return true;
}


/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	if(aheadPaymentScheFlag)
	{
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","TransSerialNo="+transactionSerialNo,"");
		aheadPaymentScheFlag = false;
	}
	calcLoanRateTermID();
	calcNewFINTermID();
	calcOldFINTermID();
	openFeeList();
}

/*~[Describe=还款计划测算;InputParam=无;OutPutParam=无;]~*/
function viewConsult(){
	aheadPaymentScheFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=费用信息;InputParam=无;OutPutParam=无;]~*/
function openFeeList(){
	var obj = $('#ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
}

/*~[Describe=利率信息;InputParam=无;OutPutParam=无;]~*/
function calcLoanRateTermID(){	
	var obj = $('#ContentFrame_RatePart');
	if(typeof(obj) == "undefined" || obj == null) return;
	var sLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
	if(typeof(sLoanRateTermID) == "undefined" || sLoanRateTermID.length == 0) return;
	/*var sPutoutDate = getItemValue(0,getRow(),"LoanPutOutDate");
	var sMaturityDate = getItemValue(0,getRow(),"LoanMaturityDate");
	var termMonth = RunMethod("BusinessManage","GetUpMonths",sPutoutDate+","+sMaturityDate);*/
	OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","RightType=ReadOnly&Status=1&ObjectNo="+relaObjectNo+"&ObjectType="+relaObjectType+"&TempletNo=RateSegmentView&TermObjectType=jbo.acct.ACCT_RATE_SEGMENT&TermID="+sLoanRateTermID,"RatePart","");
}

/*~[Describe=罚息信息;InputParam=无;OutPutParam=无;]~*/
function calcNewFINTermID(){
	var obj = $('#ContentFrame_NEWFINPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("FinTermList","/Accounting/LoanDetail/LoanTerm/FinTermList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFINPart","");
}

/*~[Describe=罚息信息;InputParam=无;OutPutParam=无;]~*/
function calcOldFINTermID(){
	var obj = $('#ContentFrame_OLDFINPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("FinTermList","/Accounting/LoanDetail/LoanTerm/FinTermList.jsp","RightType=ReadOnly&Status=2&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","OLDFINPart","");
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
	calcLoanRateTermID();
	calcNewFINTermID();
	calcOldFINTermID();
	openFeeList();
}