var aheadPaymentCalcFlag = true;//控制是否需要贷款提前还款计算
var aheadPaymentScheFlag = false;//控制是否需要贷款进行还款计划测算
/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	var prePayAmt = getItemValue(0,getRow(),"PrePayAmt");
	var PrePayType = getItemValue(0,getRow(),"PrePayType");
	if(parseFloat(prePayAmt)<=0 && PrePayType != "3"){//不是全部提前还款
		alert("还款总金额不能小于等于0");
		setItemValue(0,getRow(),"PrePayAmt",0);
		return false;
	}
	
	return true;
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
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

/*~[Describe=根据提前还款咨询;InputParam=后续事件;OutPutParam=无;]~*/
function repayConsult(){
	var prePayAmt = getItemValue(0,getRow(),"PrePayAmt");
	var transStatus = getItemValue(0,getRow(),"TransStatus");
	if(typeof(transStatus)=="undefined"||transStatus.length==0 || transStatus !="0"){
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

/*~[Describe=根据提前还款方式不同触发该事件;InputParam=后续事件;OutPutParam=无;]~*/
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