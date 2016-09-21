var aheadPaymentScheFlag = false;//控制是否需要贷款进行还款计划测算
/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	try{
		myiframe0.NEWRPTPart.saveRecord();
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
	calcNewRPTTermID();
	calcOldRPTTermID();
	openFeeList();
	checkRPT25();
}

/*~[Describe=还款计划测算;InputParam=无;OutPutParam=无;]~*/
function viewConsult(){
	checkRPT25();
	aheadPaymentScheFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=费用信息;InputParam=无;OutPutParam=无;]~*/
function openFeeList(){
	//var obj = $('#ContentFrame_NEWFEEPart');
	var obj = $('#ContentFrame_NEWFEEPart');
	//if(typeof(obj) == "undefined" || obj == null || typeof(obj_dw) == "undefined" || obj_dw == null) return;
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("AcctFeeList","/Accounting/LoanDetail/LoanTerm/AcctFeeList.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"","NEWFEEPart","");
}

/*~[Describe=还款方式信息;InputParam=无;OutPutParam=无;]~*/
function calcNewRPTTermID(){
	var obj = $('#ContentFrame_NEWRPTPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
	if(typeof(sRPTTermID) == "undefined" || sRPTTermID.length == 0) return;
	if(sRPTTermID=="RPT20"){
		var businessSum=getItemValue(0,getRow(),"NormalBalance");
		var putOutDate=businessDate;
		var maturity=getItemValue(0,getRow(),"LoanMaturityDate");
		OpenComp("RPTTermList","/Accounting/LoanDetail/LoanTerm/RPTTermList.jsp","Status=0@1&ToInheritObj=y&Maturity="+maturity+"&PutOutDate="+putOutDate+"&BusinessSum="+businessSum+"&ObjectType="+documentType+"&ObjectNo="+documentSerialNo+"&TermID="+sRPTTermID,"NEWRPTPart","");
	}else if(sRPTTermID=="RPT25"){
		OpenComp("InteBusinessTermView","/Accounting/LoanDetail/LoanTerm/InteBusinessTermView.jsp","Status=0&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RPTSegmentView&TermObjectType=jbo.acct.ACCT_RPT_SEGMENT&TermID="+sRPTTermID,"NEWRPTPart","");
	}else{
		var setFlag = RunMethod("LoanAccount","GetTermFlag",sRPTTermID);
		if(setFlag=="SET@020")
			OpenComp("SetBusinessTermView","/Accounting/LoanDetail/LoanTerm/SetBusinessTermView.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RPTSegmentView&TermObjectType=jbo.acct.ACCT_RPT_SEGMENT&TermID="+sRPTTermID,"NEWRPTPart","");
		else
			OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Status=0@1&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RPTSegmentView&TermObjectType=jbo.acct.ACCT_RPT_SEGMENT&TermID="+sRPTTermID,"NEWRPTPart","");
	}
}

/*~[Describe=原还款方式信息;InputParam=无;OutPutParam=无;]~*/
function calcOldRPTTermID(){
	//var obj = frames['myiframe0'].document.getElementById('ContentFrame_OLDRPTPart');
	var obj = $('#ContentFrame_OLDRPTPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	var sOLDRPTTermID = getItemValue(0,getRow(),"OLDRPTTermID");
	if(typeof(sOLDRPTTermID) == "undefined" || sOLDRPTTermID.length == 0) return;
	if(sOLDRPTTermID =="RPT25")
		OpenComp("InteBusinessTermView","/Accounting/LoanDetail/LoanTerm/InteBusinessTermView.jsp","RightType=ReadOnly&Status=2&ToInheritObj=y&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RPTSegmentView&TermObjectType=jbo.acct.ACCT_RPT_SEGMENT&TermID="+sOLDRPTTermID,"OLDRPTPart","");
	else {
		var setFlag = RunMethod("LoanAccount","GetTermFlag",sOLDRPTTermID);
		if(setFlag=="SET@020")
			OpenComp("SetBusinessTermView","/Accounting/LoanDetail/LoanTerm/SetBusinessTermView.jsp","RightType=ReadOnly&Status=2&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RPTSegmentView&TermObjectType=jbo.acct.ACCT_RPT_SEGMENT&TermID="+sOLDRPTTermID,"OLDRPTPart","");
		else
			OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","RightType=ReadOnly&Status=2&ObjectNo="+documentSerialNo+"&ObjectType="+documentType+"&TempletNo=RPTSegmentView&TermObjectType=jbo.acct.ACCT_RPT_SEGMENT&TermID="+sOLDRPTTermID,"OLDRPTPart","");
	}
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
	calcNewRPTTermID();
	calcOldRPTTermID();
	openFeeList();
}

/*~[Describe=分期换本表还款方式校验;InputParam=无;OutPutParam=无;]~*/
function checkRPT25(objectType,objectNo) {
	var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
	if(typeof(sRPTTermID) == "undefined" ||sRPTTermID==null|| sRPTTermID.length == 0) return;
	if(sRPTTermID=="RPT25") {
		var businessSum=getItemValue(0,getRow(),"NormalBalance");
		if (typeof(businessSum)=="undefined" || businessSum.length==0||businessSum==null){
			alert("请先确认贷款正常本金余额!");
			return;
		}
		var putOutDate = getItemValue(0,getRow(),"LoanPutOutDate");
		var maturity=getItemValue(0,getRow(),"LoanMaturityDate");
		if ((typeof(putOutDate)=="undefined" || putOutDate.length==0||putOutDate==0||putOutDate==null)
					||(typeof(maturity)=="undefined" ||maturity.length==0||maturity==0||maturity==null)
					||maturity==putOutDate){
				alert("请先录入贷款期限或日期!");
				return;
		}		
		var sReturn = RunMethod("BusinessManage","CheckRPT25",putOutDate+","+maturity+","+businessSum+","+documentType+","+documentSerialNo);
		if(sReturn.split("@")[0]=="false") {
			alert(sReturn.split("@")[1]);
			return;
		}
	}
}