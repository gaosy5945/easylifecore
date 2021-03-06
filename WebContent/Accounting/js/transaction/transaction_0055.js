var aheadPaymentCalcFlag = true;//控制是否需要贷款提前还款计算
var aheadPaymentScheFlag = false;//控制是否需要贷款进行还款计划测算
/*~[Describe=保存前校验方法;InputParam=无;OutPutParam=无;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("生效日期不能早于当前日期");
		return false;
	}
	
	var actualPayAmt = getItemValue(0,getRow(),"PrepayAmount");
	var PrePayType = getItemValue(0,getRow(),"PrePayType");
	/*if(actualPayAmt<=0 && PrePayType != "10"){//不是全部提前还款
		alert("还款总金额不能小于等于0");
		setItemValue(0,getRow(),"ActualPayAmt",0);
		return false;
	}*/
	//校验账号必输
	var payAccountFlag = getItemValue(0,getRow(),"PayAccountFlag");
	if(typeof(payAccountFlag)=="undefined"||payAccountFlag.length==0){
		alert("必须引入还款账号!");
		//return false;
	}
	
	return true;
}

/*~[Describe=费用信息;InputParam=无;OutPutParam=无;]~*/
function openFeeList(){
	//var obj = document.getElementById('ContentFrame_NEWFEEPart');
	//var obj = window.frames["NEWFEEPart"];
	var obj = $('#ContentFrame_NEWFEEPart');
	if(typeof(obj) == "undefined" || obj == null) return;
	OpenComp("TransactionFeeList","/Accounting/Transaction/TransactionFeeList.jsp","ToInheritObj=y&ParentTransSerialNo="+transactionSerialNo,"NEWFEEPart","");
}

/*~[Describe=保存后续逻辑;InputParam=无;OutPutParam=无;]~*/
function afterSave(){
	if(aheadPaymentCalcFlag)
	{
		var apcs=popComp("AheadPaymentConsult","/Accounting/Transaction/AheadPaymentConsult.jsp","TransactionSerialNo="+transactionSerialNo,"dialogWidth=50;dialogHeight=30;");
		if(typeof(apcs) != "undefined" && apcs.length != 0)
		{
			var payAmt = apcs.split("@")[0];
			var prePayPrincipalAmt = apcs.split("@")[1];
			var prePayInteAmt = apcs.split("@")[2];
			setItemValue(0,0,"ActualPayAmt",payAmt);
			setItemValue(0,0,"PrePayPrincipalAmt",prePayPrincipalAmt);
			setItemValue(0,0,"PrePayInteAmt",prePayInteAmt);
		}
	}
	var isPrepayAll = getItemValue(0,getRow(),"PrePayType");
	if(aheadPaymentScheFlag && isPrepayAll!='10')
	{
		PopComp("ViewPrepaymentConsult","/Accounting/Transaction/ViewPrepaymentConsult.jsp","ToInheritObj=y&TransSerialNo="+transactionSerialNo,"");
		aheadPaymentScheFlag = false;
	}
	changePrepayType();
	openFeeList();
}

/*~[Describe=根据提前还款咨询;InputParam=后续事件;OutPutParam=无;]~*/
function repayConsult(){
	/*
	if(sActualPayAmt>sPayAmt){
		alert("还款本金必须小于还款总金额");
		return;
	}*/
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
	/*setItemValue(0,getRow(),"INPUTUSERID",curUserID);
	setItemValue(0,getRow(),"INPUTUSERNAME",curUserName);
	setItemValue(0,getRow(),"INPUTORGID",curOrgID);
	setItemValue(0,getRow(),"INPUTORGNAME",curOrgName);
	setItemValue(0,getRow(),"INPUTDATE",businessDate);
	setItemValue(0,getRow(),"UPDATEUSERID",curUserID);
	setItemValue(0,getRow(),"UPDATEUSERNAME",curUserName);
	setItemValue(0,getRow(),"UPDATEORGID",curOrgID);
	setItemValue(0,getRow(),"UPDATEORGNAME",curOrgName);
	setItemValue(0,getRow(),"UPDATEDATE",businessDate);
	setItemValue(0,getRow(),"PayPrincipalAmt",payPrincipalAmt);
	setItemValue(0,getRow(),"PayInteAmt",payInteAmt);*/
	setValue("TransDate",businessDate);
	setItemValue(0,getRow(),"PrepayInterestDaysFlag","02");
	changePrepayType();
	openFeeList();
	changeCashOnlineFlag();
}

/*~[Describe=根据提前还款方式不同触发该事件;InputParam=后续事件;OutPutParam=无;]~*/
function changePrepayType(){
	var dNormalBalance = getItemValue(0,getRow(),"NormalBalance");
	var dOverdueBalance = getItemValue(0,getRow(),"OverDueBalance");
	var sPrePayType = getItemValue(0,0,"PrePayType");
	if(typeof(sPrePayType)=="undefined" || sPrePayType.length==0){
		return;
	}
	if(sPrePayType == "10"){
		setItemValue(0,0,"PrePayAmountFlag","1");
		setItemDisabled(0,0,"PrePayAmountFlag",true);
		setItemValue(0,0,"PrepayAmount",parseFloat(dNormalBalance));
		setItemDisabled(0,0,"PrepayAmount",true);
		setItemDisabled(0,0,"ActualPayAmt",true);
		setItemValue(0,0,"PrepayInterestBaseFlag","02");
		setItemDisabled(0,0,"PrepayInterestBaseFlag",true);
	}else{
		var sPrepayInterestDaysFlag = getItemValue(0,0,"PrepayInterestDaysFlag");
		if(typeof(sPrepayInterestDaysFlag)=="undefined" || sPrepayInterestDaysFlag.length==0){
			return;
		}
		setItemDisabled(0,0,"PrePayAmountFlag",false);
		setItemDisabled(0,0,"PrepayAmount",false);
		setItemDisabled(0,0,"PrepayInterestBaseFlag",false);
		setItemDisabled(0,0,"PrepayInterestDaysFlag",false);
		if(sPrepayInterestDaysFlag=="03"){
			setItemValue(0,0,"PrepayInterestBaseFlag","02");
			setItemDisabled(0,0,"PrepayInterestBaseFlag",true);
		}
		else{
			setItemDisabled(0,0,"PrepayInterestBaseFlag",false);
		} 
	}
	
}