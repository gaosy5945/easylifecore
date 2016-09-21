var aheadPaymentScheFlag = false;//控制是否需要贷款进行还款计划测算
/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
		alert("必须引入还款账号!");
		return false;
	}
	
	return true;
}

/*~[Describe=费用信息;InputParam=无;OutPutParam=无;]~*/
function openFeeList(){
	var obj = $('#ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("TransactionFeeList","/Accounting/Transaction/TransactionFeeList.jsp","ToInheritObj=y&ParentTransSerialNo="+transactionSerialNo,"NEWFEEPart","");
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	
}

/*~[Describe=根据提前还款咨询;InputParam=后续事件;OutPutParam=无;]~*/
function repayConsult(){
	var sTransStatus = getItemValue(0,getRow(),"TransStatus");
	if(typeof(sTransStatus)=="undefined"||sTransStatus.length==0 || sTransStatus !="0"){
		alert("此笔交易状态不是待提交,不允许试算!");
		return;
	}
	aheadPaymentCalcFlag = true;
	saveRecord("afterSave();");
}

/*~[Describe=还款计划测算;InputParam=无;OutPutParam=无;]~*/
function viewConsult(){
	aheadPaymentScheFlag = true;
	saveRecord("afterSave();");
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
	setItemValue(0,getRow(),"PayPrincipalAmt",payPrincipalAmt);
	setItemValue(0,getRow(),"PayInteAmt",payInteAmt);
	setValue("TransDate",businessDate);
	setItemValue(0,getRow(),"PrepayInterestDaysFlag","02");
	openFeeList();
	changeCashOnlineFlag();
}
